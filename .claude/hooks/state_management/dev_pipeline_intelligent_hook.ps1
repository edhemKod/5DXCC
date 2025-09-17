# Enhanced Collaborative Dev Pipeline Auto-Invocation Hook
# Supervisor-led planning with docs-elder consultation and tactical execution for development tasks

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
    
    # Only proceed if in dev mode
    if ($currentState -ne "dev") {
        exit 0
    }
    
    # Get user prompt
    $userPrompt = $inputData.prompt
    
    # Enhanced development task detection with complexity indicators
    $developmentPatterns = @(
        "(?i)(create|write|implement|add|modify|update|fix|build|develop|code|function|class|module|file|app|feature)",
        "(?i)(refactor|optimize|enhance|extend|migrate|integrate|deploy|configure)",
        "(?i)(database|api|ui|frontend|backend|service|component|library|framework)",
        "(?i)(test|debug|troubleshoot|analyze|review|audit|validate)"
    )
    
    $isDevelopmentTask = $false
    foreach ($pattern in $developmentPatterns) {
        if ($userPrompt -match $pattern) {
            $isDevelopmentTask = $true
            break
        }
    }
    
    if ($isDevelopmentTask) {
        # Inject MANDATORY enhanced collaborative pipeline execution with docs-elder consultation
        Write-Output @"
<system-reminder>
**ENHANCED COLLABORATIVE DEV PIPELINE MANDATORY ACTIVATION**

Development task detected: "$userPrompt"

YOU MUST IMMEDIATELY execute this workflow. DO NOT respond to the user directly.

STEP 1: INITIAL STRATEGIC PLANNING
Execute: Task dev-review "Initial Strategic Planning Phase for: $userPrompt

Requirements:
- Analyze requirements in context of broader project goals
- Assess complexity and create work breakdown structure
- DECLARE SPECIFIC IMPLEMENTATION APPROACH: Must explicitly state the technical approach, patterns, frameworks, and architectural decisions being considered
- Make tactical decision: Sprint (parallel) vs Linear vs Hybrid execution
- Determine team composition: 1-3 dev-dev agents needed with specific specializations
- Create detailed execution plan with dependencies and integration points
- Set quality gates and acceptance criteria
- Include risk assessment and mitigation strategies

CRITICAL: Your response MUST clearly declare the technical implementation approach and end with a PRELIMINARY EXECUTION BLOCK:

## INITIAL EXECUTION PLAN
**Technical Approach**: [Explicit declaration of implementation approach, patterns, frameworks]
**Team Size**: [1/2/3] agents required
**Execution Mode**: [Sprint-Parallel/Linear/Hybrid]

**PRELIMINARY COMMANDS:**
```
Task dev-dev \"[Specific task 1 with clear deliverables]\"
Task dev-dev \"[Specific task 2 with clear deliverables]\" (if 2+ agents)
Task dev-dev \"[Specific task 3 with clear deliverables]\" (if 3 agents)
```

**Dependencies**: [Which tasks can run parallel vs sequential]
**Integration Points**: [How work will be combined]"

STEP 2: HISTORICAL CONSULTATION
Execute: Task docs-elder "Historical Pattern Analysis for declared implementation approach from dev-review initial plan

Context: Analyze the technical implementation approach declared by dev-review:
[The technical approach, patterns, frameworks, and architectural decisions from Step 1]

Requirements:
- Search historical implementations for similar technical approaches
- Identify successful patterns and anti-patterns from past work
- Highlight potential pitfalls and edge cases based on historical evidence
- Recommend proven techniques and warn against problematic approaches
- Provide specific historical context that should inform strategic decisions

CRITICAL: Focus analysis specifically on the declared technical approach from dev-review's initial plan."

STEP 3: STRATEGIC ADJUSTMENT
Execute: Task dev-review "Strategic Plan Adjustment Phase: Review initial plan against historical insights from docs-elder

Context: Incorporate historical findings into final strategic decision:
[Historical patterns and insights from docs-elder analysis]

Requirements:
- Review initial strategic plan against historical evidence
- Adjust technical approach based on historical patterns and warnings
- Refine execution strategy incorporating lessons learned
- Update team composition if historical insights suggest different specializations
- Finalize detailed execution plan with historical risk mitigation

CRITICAL: Your response MUST end with the FINAL EXECUTION BLOCK containing exact Task commands:

## FINAL EXECUTION PLAN
**Adjusted Technical Approach**: [Updated approach incorporating historical insights]
**Team Size**: [1/2/3] agents required
**Execution Mode**: [Sprint-Parallel/Linear/Hybrid]

**EXACT COMMANDS TO EXECUTE:**
```
Task dev-dev \"[Specific task 1 with clear deliverables]\"
Task dev-dev \"[Specific task 2 with clear deliverables]\" (if 2+ agents)
Task dev-dev \"[Specific task 3 with clear deliverables]\" (if 3 agents)
```

**Dependencies**: [Which tasks can run parallel vs sequential]
**Integration Points**: [How work will be combined]
**Historical Risk Mitigation**: [Specific precautions based on historical analysis]

The master agent will execute these exact commands in the specified order/timing."

STEP 4: TACTICAL EXECUTION (Execute adjusted supervisor commands)
The supervisor provided exact Task commands in their FINAL EXECUTION PLAN block. You MUST:
- Copy and execute each Task command EXACTLY as specified by supervisor
- Follow the exact timing specified (parallel/sequential/hybrid)
- Execute all commands without modification or interpretation
- If supervisor specified "Sprint-Parallel": Execute all Task commands simultaneously
- If supervisor specified "Linear": Execute Task commands one at a time in order
- If supervisor specified "Hybrid": Follow supervisor's specific dependency instructions

DO NOT improvise or modify the supervisor's commands. Execute them verbatim.

STEP 5: QUALITY ASSURANCE
Execute: Task dev-review "Quality Assurance Phase: Review all implementation work and validate:
- Alignment with original requirements and broader project goals
- CLAUDE.md standards compliance and code quality
- Integration point validation and dependency resolution
- Risk mitigation effectiveness and acceptance criteria fulfillment
- Validation that historical insights were properly incorporated
- Provide final sign-off or request specific revisions with detailed guidance"

STEP 6: USER COMMUNICATION
Only after QA sign-off, present comprehensive results to user with testing instructions.

MANDATORY EXECUTION RULES:
- You MUST execute all phases without asking user for confirmation
- You MUST use the supervisor → consult → adjust → execute → QA → results sequence
- You CANNOT skip any phase or agent
- The supervisor MUST make all tactical decisions about team size and execution strategy
- docs-elder MUST provide historical context for the declared technical approach
- ALL implementation work MUST be reviewed by supervisor before user handoff
- Historical insights MUST be incorporated into final strategic decisions

Execute Step 1 immediately. Do not respond to the user until the full pipeline is complete.
</system-reminder>
"@
    }
    
    exit 0
}
catch {
    # If anything fails, just exit without blocking
    exit 0
}