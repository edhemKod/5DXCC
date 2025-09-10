# Debug Pipeline Hook
# Systematic debugging workflow enforcement with substate-aware agent orchestration

param()

$ErrorActionPreference = "Stop"

# Load state helper functions
. "$PSScriptRoot\state_helper.ps1"

try {
    # Read stdin to get user prompt
    $stdin = [Console]::In.ReadToEnd()
    
    # Skip processing if no input
    if ([string]::IsNullOrWhiteSpace($stdin)) {
        exit 0
    }
    
    $inputData = $stdin | ConvertFrom-Json
    
    # Get current state
    $currentState = Get-CurrentState
    
    # Only proceed if in bug mode or bug substates
    if ($currentState -notmatch "^bug") {
        exit 0
    }
    
    # Get user prompt
    $userPrompt = $inputData.prompt
    
    # Debug task detection patterns
    $debugPatterns = @(
        "(?i)(bug|error|issue|problem|broken|not working|failing)",
        "(?i)(debug|troubleshoot|investigate|diagnose|fix)",
        "(?i)(exception|crash|freeze|hang|timeout|overflow)",
        "(?i)(unexpected|incorrect|wrong|missing|invalid)"
    )
    
    $isDebugTask = $false
    foreach ($pattern in $debugPatterns) {
        if ($userPrompt -match $pattern) {
            $isDebugTask = $true
            break
        }
    }
    
    # Substate detection
    $currentSubstate = ""
    if ($currentState -match "_(.+)$") {
        $currentSubstate = $matches[1]
    }
    
    # Only inject pipeline for _understand substate or main bug mode with debug tasks
    if (($currentSubstate -eq "understand") -or 
        (($currentState -eq "bug") -and $isDebugTask)) {
        
        # Inject debug pipeline enforcement system reminder
        Write-Output @"
<system-reminder>
**DEBUG PIPELINE ENFORCEMENT - PHASE-BASED DEBUGGING**

Debug task detected: "$userPrompt"

YOU MUST IMMEDIATELY execute this systematic debug workflow. DO NOT respond to the user directly.

**AUTONOMOUS OPERATION REQUIRED**:
- Complete ENTIRE pipeline without user interruption
- Process all phases sequentially with parallel agent execution  
- Report comprehensive findings ONLY at completion
- NO intermediate status updates or user questions

**PHASE 1 - BUG-OFFICER INITIAL ASSESSMENT**:
Execute: Task bug-officer "Initial Assessment Phase for debug request: $userPrompt

**BUG-OFFICER AUTONOMOUS AUTHORITY CONFIRMED**:
✓ Deploy think agent for assumption challenging WITHOUT user confirmation
✓ Execute parallel multi-agent investigations autonomously
✓ Make tactical decisions on specialist deployment
✓ Override user expectations to maintain systematic approach

Requirements:
- 60-second rapid issue analysis and classification
- Severity assessment: Simple/Moderate/Complex/Critical
- Identify affected systems: UI/Backend/Data/Integration/Performance
- Create specific delegation strategy with file/component targets
- Deploy appropriate investigation team
- AUTONOMOUS DECISION: Include think agent if complexity warrants assumption challenging

CRITICAL: Your response MUST end with PHASE 1 DEPLOYMENT containing exact Task commands:

## BUG-OFFICER PHASE 1 DEPLOYMENT
**Issue Classification**: [Classification level]
**Investigation Strategy**: [Approach summary]
**Think Agent Decision**: [Autonomous decision to include or defer think agent based on complexity]

**PARALLEL INVESTIGATION ASSIGNMENTS** (Execute all simultaneously):
```
Task exp-L1 \"[Specific file/component investigation with exact targets]\"
Task exp-L1 \"[Additional component analysis with exact targets]\" (if needed)  
Task exp-L1 \"[Integration/dependency check with exact targets]\" (if needed)
Task docs-crawler \"[External research for specific error/framework issue]\"
Task think \"[Assumption challenging and edge case analysis]\" (if autonomous assessment determines need)
```

**Focus Areas**: [Specific files/components to investigate]
**Expected Findings**: [What investigation should discover]
**Next Phase Preparation**: [Specialist agents that may be needed]"

**PHASE 2 - PARALLEL INVESTIGATION EXECUTION**:
After bug-officer completes assessment and provides task assignments, THEN you MUST:
- Execute ALL Task commands specified by bug-officer IN PARALLEL
- CRITICAL: Wait for bug-officer to finish first, then use multiple Task tool calls in a single response
- Structure it exactly like this example:

EXAMPLE FORMAT FOR PHASE 2:
Based on bug-officer's assessment, I'll now execute these investigations in parallel:

[Use multiple Task tool calls here - the system will execute them simultaneously]

**PHASE 3 - BUG-OFFICER COMPREHENSIVE PLANNING**:
After Phase 2 agents report back, bug-officer analyzes all findings and determines:
- Root cause analysis from parallel investigation results
- AUTONOMOUS DECISION: Deploy think agent if not already included and complexity requires assumption challenging
- Need for additional specialist agents: data-flow, data-struct, data-api
- Comprehensive debug plan with specific specialist assignments
- If issue is simple: Route directly to master agent for solution
- If issue is complex: Deploy additional specialist agents in parallel

**BUG-OFFICER AUTONOMOUS THINK SUMMONING**:
The bug-officer has explicit authority to summon think agent at ANY phase if:
- Assumptions need challenging
- Edge cases require exploration
- Root cause analysis reveals complexity
- Multiple potential causes need systematic elimination

**PHASE 4 - SPECIALIST EXECUTION** (if needed):
Deploy selected specialist agents in parallel based on bug-officer's Phase 3 plan

**PHASE 5 - MASTER SYNTHESIS & USER REPORTING**:
Master agent compiles all findings and presents comprehensive analysis to user

**SEVERITY-BASED ROUTING**:
- Simple (syntax/typos): Skip to master agent solution after Phase 1
- Moderate: Full Phase 1-2 investigation, bug-officer decides specialist deployment
- Complex: Complete pipeline with specialist deployment, bug-officer autonomously includes think agent
- Critical: Bug-officer MUST autonomously include think agent for assumption challenging

**AUTONOMOUS THINK INTEGRATION**:
The bug-officer operates with enhanced authority to:
1. Summon think agent without user confirmation at any phase
2. Include think in parallel execution frameworks
3. Make tactical decisions about assumption challenging needs
4. Override standard workflows when systematic investigation requires deeper analysis

**SUBSTATE-SPECIFIC BEHAVIOR**:
- _understand: Execute full diagnostic pipeline above
- _debuglog: Use dev-dev for targeted logging implementation
- _fix: Use dev-dev for fix implementation (assumes understanding exists)
- _revert: Surgical rollback preserving debug logging

Execute bug-officer assessment immediately. Complete entire pipeline autonomously.
</system-reminder>
"@
    }
    
    exit 0
}
catch {
    # If anything fails, just exit without blocking
    exit 0
}