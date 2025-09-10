# Claude Code State Management Hook
# Detects state transition triggers and updates JSON state storage

param()

$ErrorActionPreference = "Stop"

# Load state helper functions
. "$PSScriptRoot\state_helper.ps1"

try {
    # Read stdin
    $stdin = [Console]::In.ReadToEnd()
    
    # Skip processing if no input
    if ([string]::IsNullOrWhiteSpace($stdin)) {
        exit 0
    }
    
    $inputData = $stdin | ConvertFrom-Json
    
    # Extract user message from prompt field
    $userMessage = ""
    
    if ($inputData.prompt) {
        $userMessage = $inputData.prompt.Trim()
    }
    
    # Debug log what we extracted
    # Add-Content -Path "$PSScriptRoot\log\state_debug.log" -Value "[$(Get-Date)] Extracted message: '$userMessage'"
    
    # Check for state transition triggers (including debug substates)
    $stateTransition = $null
    $substateTransition = $null
    
    if ($userMessage -match "(?i)\b_understand\b") {
        $stateTransition = "bug"
        $substateTransition = "understand"
    } elseif ($userMessage -match "(?i)\b_debuglog\b") {
        $stateTransition = "bug" 
        $substateTransition = "debuglog"
    } elseif ($userMessage -match "(?i)\b_fix\b") {
        $stateTransition = "bug"
        $substateTransition = "fix"
    } elseif ($userMessage -match "(?i)\b_revert\b") {
        $stateTransition = "bug"
        $substateTransition = "revert"
    } elseif ($userMessage -match "(?i)\b_chat\b") {
        $stateTransition = "chat"
    } elseif ($userMessage -match "(?i)\b_dev\b") {
        $stateTransition = "dev"
    } elseif ($userMessage -match "(?i)\b_bug\b") {
        $stateTransition = "bug"
        $substateTransition = $null  # Clear substate when going to main bug mode
    } elseif ($userMessage -match "(?i)\b_docs\b") {
        $stateTransition = "docs"
    } elseif ($userMessage -match "(?i)\b_exp\b") {
        $stateTransition = "exp"
    } elseif ($userMessage -match "(?i)\b_data\b") {
        $stateTransition = "data"
    } elseif ($userMessage -match "(?i)\b_vanilla\b") {
        $stateTransition = "vanilla"
    }
    
    # If state transition detected, update state and output transition message
    if ($stateTransition) {
        # Update JSON state file
        $sessionId = "session_" + (Get-Date -Format "yyyyMMdd_HHmmss")
        $stateUpdated = Set-CurrentState -NewState $stateTransition -Substate $substateTransition -SessionId $sessionId
        
        $stateNames = @{
            "chat" = "Discussion/Brainstorm/Planning"
            "dev" = "Development/Coding/Documentation"
            "bug" = "Troubleshooting/Debugging/Fixing"
            "docs" = "Documentation Review/README Updates"
            "exp" = "Codebase Exploration/Analysis"
            "data" = "Data Structure Analysis/Optimization"
            "vanilla" = "Clean Claude Code Experience"
        }
        
        $stateName = $stateNames[$stateTransition]
        
        # Include state update status in output
        $stateStatus = if ($stateUpdated) { "✅ State saved" } else { "⚠️ State save failed" }
        
        # Handle substate display
        $substateDisplay = ""
        $transitionDisplay = "_$stateTransition"
        if ($substateTransition) {
            $substateDisplay = " / $substateTransition"
            $transitionDisplay = "_$substateTransition"
        }
        
        Write-Output @"
<system-reminder>
# State Transition Detected: ``$transitionDisplay`` → **$stateName$substateDisplay**

Current State: **$stateName$substateDisplay** ($stateStatus)

$(switch ($stateTransition) {
    "chat" {
@"
**CHAT MODE ACTIVE**
- Allowed: .md files, bash for exploration, research, planning
- Blocked: Code execution, file modifications beyond .md, TodoWrite
- Focus: Codebase familiarization, planning, documentation
"@
    }
    "dev" {
@"
**DEVELOPMENT MODE ACTIVE**  
- Full capabilities enabled
- TodoWrite available for task management
- Can escalate to _bug for systematic debugging
- Focus: Implementation, coding, documentation
"@
    }
    "bug" {
        if ($substateTransition) {
            switch ($substateTransition) {
                "understand" {
@"
**DEBUG INVESTIGATION MODE (_understand)**
- Full diagnostic pipeline with bug-officer coordination
- Parallel investigation: exp-L1 agents + docs-crawler + specialists
- Autonomous operation: Complete pipeline runs start-to-finish without user interruption
- Available agents: bug-officer, exp-L1, docs-crawler, data-*, think
- Focus: Comprehensive root cause analysis and solution planning
"@
                }
                "debuglog" {
@"
**DEBUG LOGGING MODE (_debuglog)**
- Focused logging implementation with dev-dev agent
- Target specific components identified in investigation phase
- Add detailed state capture and console logging to dev/logs/
- Preserve existing functionality while adding diagnostics
"@
                }
                "fix" {
@"
**DEBUG FIX MODE (_fix)**
- Targeted fix implementation with dev-dev agent
- Apply single fix at a time following systematic approach
- Preserve all debug logging during fixes
- Based on completed understanding from _understand phase
"@
                }
                "revert" {
@"
**DEBUG REVERT MODE (_revert)**
- Surgical rollback of previous fix attempts with dev-dev agent
- PRESERVE debug logging (never revert logging - valuable for future debugging)
- Maintain application stability during rollbacks
- Targeted revert without affecting other functionality
"@
                }
            }
        } else {
@"
**DEBUGGING MODE ACTIVE**
- Multi-agent debugging workflow with specialized substates
- Available substates: _understand, _debuglog, _fix, _revert
- Use _understand to start comprehensive investigation
- Systematic approach with parallel agent execution
- Reference: CLAUDE.md Multi-Agent Debug Mode Workflow
"@
        }
    }
    "docs" {
@"
**DOCUMENTATION MODE ACTIVE**
- Mandatory folder/file review before README updates
- Only .md files can be written/edited
- Must use Read/Glob tools to explore before documenting
- TodoWrite available for tracking documentation tasks
- Focus: Comprehensive documentation review and README updates
"@
    }
    "exp" {
@"
**EXPLORATION MODE ACTIVE**
- Read-only codebase exploration and analysis
- Specialized agents available: exp-L1, exp-L2
- Blocked: All write operations, edits, todos
- Allowed: Read, Grep, Glob, Task tools only
- Focus: Understanding codebase structure and dependencies
"@
    }
    "data" {
@"
**DATA ANALYSIS MODE ACTIVE**
- Read-only data structure analysis and optimization
- Specialized agents available: data-flow, data-struct, data-api
- Blocked: All write operations, edits, todos
- Allowed: Read, Grep, Glob, Task tools only
- Focus: Identifying data flow inefficiencies and optimization opportunities
"@
    }
    "vanilla" {
@"
**VANILLA MODE ACTIVE**
- Clean Claude Code experience with no framework restrictions
- All tools and capabilities fully enabled
- No specialized agents or subagent suggestions
- No systematic debugging enforcement
- No tool usage limitations
- Focus: Unrestricted problem-solving and development
"@
    }
})
</system-reminder>
"@
    }
    
    exit 0
}
catch {
    # If anything fails, just exit without blocking
    exit 0
}