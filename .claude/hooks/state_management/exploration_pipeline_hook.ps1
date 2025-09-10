# Exploration Pipeline Hook
# L0 Gateway Enforcement for systematic exploration tasks

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
    
    # Only proceed if in exp mode
    if ($currentState -ne "exp") {
        exit 0
    }
    
    # Get user prompt
    $userPrompt = $inputData.prompt
    
    # Simplified exploration task detection patterns
    $explorationPatterns = @(
        "(?i)(explore|understand|analyze|examine|investigate|map|discover)",
        "(?i)(codebase|architecture|structure|components|modules|dependencies)", 
        "(?i)(how does|what is|where is|find|locate|identify|overview)",
        "(?i)(files|functions|classes|patterns|relationships|flow)"
    )
    
    $isExplorationTask = $false
    foreach ($pattern in $explorationPatterns) {
        if ($userPrompt -match $pattern) {
            $isExplorationTask = $true
            break
        }
    }
    
    if ($isExplorationTask) {
        # Inject L0 Gateway enforcement system reminder
        Write-Output @"
<system-reminder>
**EXPLORATION PIPELINE L0 GATEWAY ENFORCEMENT**

Exploration task detected: "$userPrompt"

YOU MUST IMMEDIATELY execute this L0 gateway workflow. DO NOT respond to the user directly.

PHASE 1 - L0 RECONNAISSANCE ONLY (Execute L0 alone first):
Execute: Task exp-L0 "Initial Assessment Phase for exploration request: $userPrompt

Requirements:
- Analyze the exploration scope and complexity
- Identify key areas of the codebase that need investigation
- Determine appropriate L1/L2 specialization needed
- Create structured exploration roadmap
- Assess risks and provide safety guidance
- Define clear deliverables and success criteria

CRITICAL: Your response MUST end with a GATEWAY DECISION containing exact Task commands:

## L0 GATEWAY DECISION
**Scope Assessment**: [Simple/Moderate/Complex]
**Recommended Specialization**: [L1-General/L1-Arch/L2-Deep/Multi-Agent]

**PARALLEL TASK ASSIGNMENTS** (Execute all simultaneously):
```
Task exp-L1 \"[Specific L1 assignment with exact file targets]\"
Task exp-L2 \"[Specific L2 assignment with exact file targets]\" (if needed)
Task exp-L1 \"[Additional L1 assignment]\" (if multiple L1 agents needed)
```

**Focus Areas**: [Specific components/modules to investigate]
**Expected Outputs**: [What user should expect to receive]
**Safety Notes**: [Any limitations or important context]

The master agent will execute these exact commands as specified by L0."

PHASE 2 - PARALLEL EXECUTION OF L0 RECOMMENDATIONS:
After L0 completes reconnaissance and provides task assignments, THEN you MUST:
- Execute ALL Task commands specified by exp-L0 IN PARALLEL (but NOT until L0 is done)
- CRITICAL: Wait for L0 to finish first, then use multiple Task tool calls in a single response
- Structure it exactly like this example:

EXAMPLE FORMAT FOR PHASE 2:
After L0 provides reconnaissance report, execute like this:
\"\"\"
Based on L0's completed reconnaissance, I'll now execute these tasks in parallel:

[Use multiple Task tool calls here - the system will execute them simultaneously]
\"\"\"

TWO-PHASE APPROACH:
1. FIRST: Execute only L0 reconnaissance (wait for completion)
2. SECOND: Execute L0's recommended L1/L2 tasks in parallel (all at once)

RESULTS PRESENTATION:
After specialist completion, present consolidated exploration results to user.

L0 GATEWAY RULES:
- L0 assessment is MANDATORY before any L1/L2 access
- Direct L1/L2 invocation without L0 gateway is BLOCKED
- L0 makes all tactical decisions about exploration strategy
- Master agent executes L0 recommendations without modification
- PARALLEL EXECUTION: All L0 task assignments execute simultaneously

Execute L0 assessment immediately. Do not respond to the user until gateway processing is complete.
</system-reminder>
"@
    }
    
    exit 0
}
catch {
    # If anything fails, just exit without blocking
    exit 0
}