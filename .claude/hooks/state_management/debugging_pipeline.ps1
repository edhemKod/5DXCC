# 4DCC Framework - Systematic Debugging Pipeline
# Extracted from CLAUDE.md and implemented as hook enforcement

param()

$ErrorActionPreference = "Stop"

# Load state helper functions
. "$PSScriptRoot\state_helper.ps1"

try {
    # Read stdin and parse
    $stdin = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($stdin)) {
        exit 0
    }
    
    $inputData = $stdin | ConvertFrom-Json
    $currentState = Get-CurrentState
    
    # Early exit for vanilla mode - no debugging pipeline restrictions
    if ($currentState -eq "vanilla") {
        exit 0
    }
    
    # Only enforce in bug mode
    if ($currentState -ne "bug") {
        exit 0
    }
    
    # Get tool information
    $toolName = $inputData.tool_name
    $toolParameters = $inputData.tool_input
    
    # Track debugging step state in separate JSON file
    $debugStateFile = "$PSScriptRoot\debug_state.json"
    $debugState = @{
        current_step = 1
        issue_description = ""
        fixes_attempted = 0
        logs_implemented = $false
        rollbacks_performed = 0
        poc_created = $false
        research_completed = $false
        timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
    
    # Read existing debug state if available
    if (Test-Path $debugStateFile) {
        try {
            $existingDebugState = Get-Content $debugStateFile -Raw | ConvertFrom-Json
            $debugState = @{
                current_step = $existingDebugState.current_step
                issue_description = $existingDebugState.issue_description
                fixes_attempted = $existingDebugState.fixes_attempted
                logs_implemented = $existingDebugState.logs_implemented
                rollbacks_performed = $existingDebugState.rollbacks_performed
                poc_created = $existingDebugState.poc_created  
                research_completed = $existingDebugState.research_completed
                timestamp = $existingDebugState.timestamp
            }
        } catch {
            # Use default debug state if file is corrupted
        }
    }
    
    # Debugging pipeline enforcement logic
    $shouldBlock = $false
    $blockReason = ""
    $guidanceMessage = ""
    
    # Check if this is a fix attempt (Write/Edit/MultiEdit)
    if ($toolName -eq "Write" -or $toolName -eq "Edit" -or $toolName -eq "MultiEdit") {
        $filePath = $toolParameters.file_path
        
        # Skip .md files and log files (allow documentation and logging)
        if ($filePath -and ($filePath.EndsWith(".md") -or $filePath.Contains("dev/logs/"))) {
            exit 0
        }
        
        # Enforce debugging pipeline steps
        switch ($debugState.current_step) {
            1 {
                # Step 1: Initial Inspection & Quick Fix Attempt
                $guidanceMessage = @"
**STEP 1: Initial Inspection & Quick Fix Attempt**

You are implementing your first fix attempt. After this:
1. Ask user to test and confirm the fix
2. If fixed → Done! 
3. If issue persists → Pipeline will advance to Step 2 (Rollback & Logging)

Current fix attempt: $($debugState.fixes_attempted + 1)
"@
                # Allow the fix but update state
                $debugState.fixes_attempted += 1
            }
            
            2 {
                # Step 2: Must implement logging first
                if (-not $debugState.logs_implemented -and -not $filePath.Contains("dev/logs/")) {
                    $shouldBlock = $true
                    $blockReason = "STEP 2 VIOLATION: Must implement comprehensive logging to dev/logs/ before attempting fixes"
                    $guidanceMessage = @"
**STEP 2: Rollback & Logging Implementation Required**

Before making any fixes, you must:
1. Completely revert your previous fix attempt
2. Implement comprehensive logging to dev/logs/ directory:
   - Create specific log files for the issue (e.g., notification_debug.log)
   - Add detailed JavaScript console logging for UI/CSS issues  
   - Add R console debug messages for server-side issues
   - Capture relevant state, computed values, and DOM properties
3. Ask user to reproduce issue and provide log output
4. Analyze logs to understand root cause

Only then proceed with evidence-based fixes.
"@
                } elseif ($filePath.Contains("dev/logs/")) {
                    # They're implementing logging - allow and update state
                    $debugState.logs_implemented = $true
                    $guidanceMessage = "✅ STEP 2: Implementing logging - good systematic approach!"
                } else {
                    # They have logging, allow evidence-based fix
                    $debugState.fixes_attempted += 1
                    $guidanceMessage = @"
**STEP 2: Evidence-Based Fix**
Logs implemented ✅ - proceeding with targeted fix based on log analysis.
Fix attempt: $($debugState.fixes_attempted + 1)
"@
                }
            }
            
            3 {
                # Step 3: Evidence-based second fix (they should have logs by now)
                if (-not $debugState.logs_implemented) {
                    $shouldBlock = $true
                    $blockReason = "STEP 3 VIOLATION: Cannot proceed without comprehensive logging from Step 2"
                } else {
                    $debugState.fixes_attempted += 1
                    $guidanceMessage = @"
**STEP 3: Evidence-Based Second Fix**
Implementing targeted solution based on log analysis.
Fix attempt: $($debugState.fixes_attempted + 1)

If this fix fails, pipeline will advance to Step 4 (POC Development & Web Research).
"@
                }
            }
            
            4 {
                # Step 4: POC Development & Web Research required
                if (-not $debugState.poc_created -and -not $debugState.research_completed) {
                    $shouldBlock = $true
                    $blockReason = "STEP 4 VIOLATION: Must create POC and complete web research before attempting fixes"
                    $guidanceMessage = @"
**STEP 4: POC Development & Web Research Required**

Before making any fixes, you must:
1. Completely revert the previous fix attempt
2. Build minimal POC to isolate the issue:
   - For UI/CSS/JS issues: Create standalone HTML/CSS/JS test file
   - For R/Shiny issues: Create minimal reproducible Shiny app
   - Include extensive debug logging and state inspection
3. Research similar issues using WebSearch:
   - Search for specific error messages, framework conflicts
   - Look for official documentation, Stack Overflow solutions, GitHub issues
4. Add enhanced logging based on research findings

Only then proceed with research-informed fixes.
"@
                } else {
                    $debugState.fixes_attempted += 1
                    $guidanceMessage = @"
**STEP 4: Research-Informed Fix**
POC and research completed ✅ - implementing solution based on findings.
Fix attempt: $($debugState.fixes_attempted + 1)
"@
                }
            }
            
            default {
                # Steps 5-7: Advanced debugging phases
                $debugState.fixes_attempted += 1
                $guidanceMessage = @"
**ADVANCED DEBUGGING: Step $($debugState.current_step)**
Deep analysis and architectural understanding phase.
Fix attempt: $($debugState.fixes_attempted + 1)

Following comprehensive debugging methodology for complex issues.
"@
            }
        }
    }
    
    # Update debug state file
    $debugState | ConvertTo-Json | Set-Content $debugStateFile
    
    # Output guidance message if provided
    if ($guidanceMessage) {
        Write-Output @"
<system-reminder>
**4DCC DEBUGGING PIPELINE ACTIVE**

$guidanceMessage

**Critical Guidelines:**
- Single Fix Rule: Only ONE fix at a time
- Always Confirm: Ask user to test after every fix attempt  
- Complete Rollback: Fully undo previous attempts before trying new solutions
- Document Everything: Keep detailed logs throughout the process

Current Step: $($debugState.current_step) | Total Fixes Attempted: $($debugState.fixes_attempted)
</system-reminder>
"@
    }
    
    # Block if violation detected
    if ($shouldBlock) {
        [Console]::Error.WriteLine("DEBUGGING PIPELINE BLOCKED: $blockReason")
        exit 2
    }
    
    exit 0
    
} catch {
    # Don't block on errors, just log
    Add-Content -Path "$PSScriptRoot\log\debug_pipeline_errors.log" -Value "[$(Get-Date)] ERROR: $($_.Exception.Message)"
    exit 0
}