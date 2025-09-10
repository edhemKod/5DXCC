# 5DXCC Framework Installation Guide
**Five-Dimensional Extended Claude Code System**

## Overview

This guide provides complete installation instructions for the 5DXCC (Five-Dimensional Extended Claude Code) framework - an intelligent state-aware development system with specialized AI agent orchestration. The framework adapts behavior based on development context and provides automated workflows through multi-dimensional intelligence.

## Framework Architecture

### Core Dimensions
1. **State Management** - Dynamic behavior adaptation (`_dev`, `_exp`, `_bug`, `_data`, `_docs`, `_chat`)
2. **Hook System** - Automated behavior control and workflow enforcement
3. **Agent Orchestration** - Specialized AI agents for different development aspects  
4. **Configuration Management** - Permission control and security models
5. **Workflow Orchestration** - Coordinated multi-agent development pipelines

### Key Benefits
- **Context-Aware Development**: System behavior adapts to current development phase
- **Specialized Expertise**: Each agent excels in specific domain areas
- **Quality Assurance**: Built-in review and validation processes
- **Workflow Automation**: Repetitive patterns automated through intelligent detection

## Installation Process

### Prerequisites
- Claude Code CLI installed and configured
- PowerShell (Windows) or equivalent shell with JSON processing capability
- Git repository (recommended)

### Installation Steps

**Step 1**: Save this entire guide as a markdown file in your project root.

**Step 2**: Copy and execute this installation script in your Claude Code session:

```
I need to install the 5DXCC framework. Please execute this installation:

1. Create the .claude directory structure if it doesn't exist
2. Check for existing CLAUDE.md and settings.local.json configurations  
3. Extract and install all framework files from the code blocks below
4. Merge configurations non-destructively (append to CLAUDE.md, merge essential hooks to settings.local.json)
5. Set up the initial state management system

Please proceed with the installation using the files provided in the sections below.
```

## Framework Files

### Directory Structure
```
.claude/
├── agents/                    # AI agent definitions
├── hooks/
│   ├── behavior_control/      # Behavior modification hooks
│   └── state_management/      # State transition and validation hooks
├── knowledge/
│   └── regex/                 # Regex patterns and language-specific rules
├── settings.local.json        # Main configuration file
├── state.json                 # Current system state
└── 5DXCC-SYSTEM-DOCUMENTATION.md
```

### Core Configuration Files

#### .claude/settings.local.json
```json
{
  "env": {
    "DISABLE_AUTOUPDATER": "1"
  },
  "permissions": {
    "allow": [
      "Bash(powershell:*)",
      "WebSearch",
      "WebFetch(domain:github.com)",
      "WebFetch(domain:stackoverflow.com)",
      "Bash(rg:*)",
      "Bash(find:*)",
      "Bash(cat:*)"
    ],
    "deny": [],
    "ask": [],
    "defaultMode": "acceptEdits"
  },
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File \".claude/hooks/behavior_control/no_you_are_right_hook.ps1\""
          },
          {
            "type": "command", 
            "command": "powershell -ExecutionPolicy Bypass -File \".claude/hooks/state_management/state_management_hook.ps1\""
          },
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File \".claude/hooks/state_management/dev_pipeline_intelligent_hook.ps1\""
          },
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File \".claude/hooks/state_management/data_pipeline_auto_hook.ps1\""
          },
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File \".claude/hooks/state_management/exploration_pipeline_hook.ps1\""
          },
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File \".claude/hooks/state_management/debug_pipeline_hook.ps1\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File \".claude/hooks/state_management/state_validation_hook.ps1\""
          },
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File \".claude/hooks/state_management/debugging_pipeline.ps1\""
          }
        ]
      }
    ]
  },
  "statusLine": {
    "type": "command",
    "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \".claude/hooks/state_management/statusline_4dcc.ps1\""
  }
}
```

#### .claude/state.json
```json
{
  "current_state": "dev",
  "substate": null,
  "timestamp": "2025-01-01T00:00:00Z",
  "session_id": "default",
  "previous_state": null,
  "transition_count": 1
}
```

### State Management System

#### .claude/hooks/state_management/state_helper.ps1
```powershell
# State Management Helper Functions
# Shared functions for reading/writing JSON state

# Read current state from JSON file
function Get-CurrentState {
    param(
        [string]$StateFile = ".claude/state.json"
    )
    
    try {
        if (Test-Path $StateFile) {
            $stateContent = Get-Content $StateFile -Raw | ConvertFrom-Json
            return $stateContent.current_state
        } else {
            # Default to dev mode if no state file
            return "dev"
        }
    } catch {
        # If any error reading state, default to dev
        return "dev"
    }
}

# Write new state to JSON file
function Set-CurrentState {
    param(
        [string]$NewState,
        [string]$Substate = $null,
        [string]$StateFile = ".claude/state.json",
        [string]$SessionId = "default"
    )
    
    try {
        $currentTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        $previousState = $null
        $transitionCount = 1
        
        # Read existing state if file exists
        if (Test-Path $StateFile) {
            $existingState = Get-Content $StateFile -Raw | ConvertFrom-Json
            $previousState = $existingState.current_state
            $transitionCount = $existingState.transition_count + 1
        }
        
        $newStateObject = @{
            current_state = $NewState
            substate = $Substate
            timestamp = $currentTime
            session_id = $SessionId
            previous_state = $previousState
            transition_count = $transitionCount
        }
        
        $newStateObject | ConvertTo-Json | Set-Content $StateFile
        return $true
    } catch {
        return $false
    }
}

# Validate parallel execution framework compatibility
function Test-ParallelExecutionCompatibility {
    param(
        [string]$CurrentState = $null,
        [string[]]$AgentTypes = @()
    )
    
    if (-not $CurrentState) {
        $CurrentState = Get-CurrentState
    }
    
    # Check if current state supports parallel execution
    $supportsParallel = $false
    $maxAgents = 1
    $compatibleAgents = @()
    
    if ($CurrentState -match "^bug") {
        $supportsParallel = $true
        $maxAgents = 6
        $compatibleAgents = @("bug-officer", "exp-L1", "docs-crawler", "data-flow", "data-struct", "data-api", "think", "regex-expert", "general-purpose", "master")
    }
    elseif ($CurrentState -eq "exp") {
        $supportsParallel = $true
        $maxAgents = 5
        $compatibleAgents = @("exp-L0", "exp-L1", "exp-L2", "think", "docs-crawler", "general-purpose", "master")
    }
    elseif ($CurrentState -eq "data") {
        $supportsParallel = $true
        $maxAgents = 5
        $compatibleAgents = @("data-flow", "data-struct", "data-api", "docs-crawler", "general-purpose", "master")
    }
    elseif ($CurrentState -eq "dev") {
        $supportsParallel = $true
        $maxAgents = 4
        $compatibleAgents = @("dev-review", "dev-dev", "general-purpose", "master")
    }
    else {
        # Default compatibility for other states
        $supportsParallel = $false
        $maxAgents = 1
        $compatibleAgents = @("general-purpose", "master")
    }
    
    # Validate requested agents
    $validatedAgents = @()
    
    foreach ($agent in $AgentTypes) {
        if ($agent -in $compatibleAgents) {
            $validatedAgents += $agent
        }
    }
    
    return @{
        SupportsParallelExecution = $supportsParallel
        MaxAgents = $maxAgents
        RequestedAgents = $AgentTypes.Count
        ValidatedAgents = $validatedAgents
        CanExecuteInParallel = ($validatedAgents.Count -le $maxAgents -and $supportsParallel)
        CompatibilityPassed = ($validatedAgents.Count -eq $AgentTypes.Count -and $supportsParallel)
    }
}
```

#### .claude/hooks/state_management/state_management_hook.ps1
```powershell
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
    } elseif ($userMessage -match "(?i)\b_exp\b") {
        $stateTransition = "exp"
    } elseif ($userMessage -match "(?i)\b_bug\b") {
        $stateTransition = "bug"
    } elseif ($userMessage -match "(?i)\b_docs\b") {
        $stateTransition = "docs"
    } elseif ($userMessage -match "(?i)\b_data\b") {
        $stateTransition = "data"
    } elseif ($userMessage -match "(?i)\b_vanilla\b") {
        $stateTransition = "vanilla"
    }
    
    # If state transition detected, update state
    if ($stateTransition) {
        $currentState = Get-CurrentState
        
        # Only update if different from current state or substate
        if ($currentState -ne $stateTransition) {
            $success = Set-CurrentState -NewState $stateTransition -Substate $substateTransition -SessionId "session-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            
            if ($success) {
                # Add state transition context
                $contextMessage = @"

## STATE TRANSITION DETECTED: $($stateTransition.ToUpper())
$(if ($substateTransition) { "**Substate**: $substateTransition" })

**Available Operations**:
$(switch ($stateTransition) {
    "dev" { "- Full tool access with development agents (dev-review, dev-dev)`n- Intelligent pipeline auto-invocation`n- Standards enforcement active" }
    "exp" { "- Read-only tool access`n- Exploration agents available (exp-L1, exp-L2)`n- Write operations blocked" }
    "bug" { "- 7-step systematic debugging pipeline`n- Bug-officer coordination available`n- All investigation agents accessible" }
    "data" { "- Specialized data analysis agents`n- Automated data pipeline workflows`n- Structure and flow optimization focus" }
    "docs" { "- Documentation-focused operations`n- Markdown editing and review capabilities`n- External knowledge gathering tools" }
    "chat" { "- Conversational discovery mode`n- Minimal tool restrictions`n- Planning and discussion focus" }
    default { "- Standard Claude Code behavior`n- Basic tool access`n- No specialized workflows" }
})

$(if ($stateTransition -eq "bug" -and $substateTransition) {
    switch ($substateTransition) {
        "understand" { "**DEBUG SUBSTATE**: Full diagnostic investigation pipeline activated" }
        "debuglog" { "**DEBUG SUBSTATE**: Targeted logging implementation mode" }
        "fix" { "**DEBUG SUBSTATE**: Focused fix implementation mode" }
        "revert" { "**DEBUG SUBSTATE**: Surgical rollback capability active" }
    }
})

---

"@
                
                Write-Host $contextMessage
            }
        }
    }
    
    exit 0
} catch {
    # Fail gracefully - don't break Claude Code if hook fails
    exit 0
}
```

#### .claude/hooks/state_management/state_validation_hook.ps1
```powershell
# State Validation Hook
# Enforces state-based tool restrictions and provides guidance

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
    
    # Get current state
    $currentState = Get-CurrentState
    
    # Extract tool information
    $toolName = ""
    $toolCall = ""
    
    if ($inputData.tool -and $inputData.tool.name) {
        $toolName = $inputData.tool.name
        $toolCall = $inputData | ConvertTo-Json -Compress
    }
    
    # Define state-based restrictions
    $restrictions = @{
        "exp" = @{
            BlockedTools = @("Write", "Edit", "MultiEdit", "NotebookEdit", "Bash")
            AllowedTools = @("Read", "Glob", "Grep", "Task", "WebSearch", "WebFetch")
            Message = "EXPLORATION MODE: Read-only operations only. Use _dev to enable write operations."
        }
        "data" = @{
            BlockedTools = @("Write", "Edit", "MultiEdit", "NotebookEdit")
            AllowedTools = @("Read", "Glob", "Grep", "Task", "Bash", "WebSearch", "WebFetch")
            Message = "DATA ANALYSIS MODE: Write operations restricted. Use _dev for code modifications."
        }
    }
    
    # Check if current state has restrictions
    if ($restrictions.ContainsKey($currentState)) {
        $stateRestriction = $restrictions[$currentState]
        
        # Check if tool is blocked
        if ($toolName -in $stateRestriction.BlockedTools) {
            Write-Host ""
            Write-Host "❌ TOOL BLOCKED: $toolName operation not permitted in $($currentState.ToUpper()) mode"
            Write-Host $stateRestriction.Message
            Write-Host ""
            exit 1
        }
    }
    
    # Task tool validation for agent restrictions
    if ($toolName -eq "Task") {
        $taskPattern = $null
        if ($inputData.tool.parameters -and $inputData.tool.parameters.task) {
            $taskPattern = $inputData.tool.parameters.task
        }
        
        # Define allowed agents per state
        $allowedAgents = @{
            "exp" = @("exp-L1", "exp-L2", "think", "general-purpose", "docs-crawler", "master")
            "data" = @("data-flow", "data-struct", "data-api", "general-purpose", "docs-crawler", "master")
            "bug" = @("bug-officer", "exp-L1", "exp-L2", "data-flow", "data-struct", "data-api", "think", "regex-expert", "general-purpose", "docs-crawler", "master")
            "docs" = @("general-purpose", "docs-crawler", "master")
            "chat" = @("general-purpose", "master")
        }
        
        if ($allowedAgents.ContainsKey($currentState)) {
            $stateAllowedAgents = $allowedAgents[$currentState]
            
            # Check if task contains blocked agent
            $blockedAgents = @("dev-review", "dev-dev")
            foreach ($blockedAgent in $blockedAgents) {
                if ($taskPattern -match "@$blockedAgent\b") {
                    if ($blockedAgent -notin $stateAllowedAgents) {
                        Write-Host ""
                        Write-Host "❌ AGENT BLOCKED: $blockedAgent not available in $($currentState.ToUpper()) mode"
                        Write-Host "Available agents: $($stateAllowedAgents -join ', ')"
                        Write-Host "Use _dev mode to access development agents"
                        Write-Host ""
                        exit 1
                    }
                }
            }
        }
    }
    
    exit 0
} catch {
    # Fail gracefully - don't break Claude Code if hook fails
    exit 0
}
```

### Behavior Control Hooks

#### .claude/hooks/behavior_control/no_you_are_right_hook.ps1
```powershell
# Behavior Control Hook
# Prevents reflexive agreement patterns and enforces critical analysis

param()

try {
    # Read stdin
    $stdin = [Console]::In.ReadToEnd()
    
    # Skip processing if no input
    if ([string]::IsNullOrWhiteSpace($stdin)) {
        exit 0
    }
    
    $inputData = $stdin | ConvertFrom-Json
    $userMessage = ""
    
    if ($inputData.prompt) {
        $userMessage = $inputData.prompt.Trim().ToLower()
    }
    
    # Detect patterns that suggest need for critical analysis
    $criticalAnalysisPatterns = @(
        "implement.*without.*review",
        "quickly.*add.*feature",
        "just.*make.*it.*work",
        "simple.*fix",
        "easy.*solution",
        "obvious.*problem"
    )
    
    $needsCriticalAnalysis = $false
    foreach ($pattern in $criticalAnalysisPatterns) {
        if ($userMessage -match $pattern) {
            $needsCriticalAnalysis = $true
            break
        }
    }
    
    # Add system reminder for critical analysis when needed
    if ($needsCriticalAnalysis) {
        $reminder = @"

## CRITICAL ANALYSIS REQUIRED
This request suggests a need for careful technical evaluation. Please:
- Challenge assumptions and identify potential issues
- Consider edge cases and failure modes  
- Evaluate technical tradeoffs objectively
- Provide evidence-based recommendations
- Point out any overlooked complexity

Focus on what will work in production, not just theory.

"@
        
        Write-Host $reminder
    }
    
    exit 0
} catch {
    # Fail gracefully
    exit 0
}
```

### Pipeline Automation Hooks

#### .claude/hooks/state_management/dev_pipeline_intelligent_hook.ps1
```powershell
# Development Pipeline Intelligent Hook
# Auto-detects complex development tasks and triggers supervisor-led workflows

param()

try {
    # Read stdin
    $stdin = [Console]::In.ReadToEnd()
    
    if ([string]::IsNullOrWhiteSpace($stdin)) {
        exit 0
    }
    
    $inputData = $stdin | ConvertFrom-Json
    $userMessage = ""
    
    if ($inputData.prompt) {
        $userMessage = $inputData.prompt.Trim()
    }
    
    # Load state helper
    . "$PSScriptRoot\state_helper.ps1"
    $currentState = Get-CurrentState
    
    # Only activate in dev mode
    if ($currentState -ne "dev") {
        exit 0
    }
    
    # Detect complex development patterns that need supervisor review
    $complexPatterns = @(
        "implement.*authentication",
        "add.*database.*integration", 
        "create.*api.*endpoint",
        "build.*new.*feature",
        "refactor.*architecture",
        "migrate.*to.*new.*framework",
        "security.*implementation",
        "performance.*optimization"
    )
    
    $isComplexTask = $false
    foreach ($pattern in $complexPatterns) {
        if ($userMessage -match "(?i)$pattern") {
            $isComplexTask = $true
            break
        }
    }
    
    if ($isComplexTask) {
        $guidance = @"

## COMPLEX DEVELOPMENT TASK DETECTED
**Recommended Workflow**: Supervisor → Developer → QA Pipeline

**Suggested Approach**:
1. **Task @dev-review** "Review architecture and approach for: [your request]"
2. Wait for supervisor approval and implementation guidelines
3. **Task @dev-dev** "Implement following supervisor guidelines: [approved approach]"

This ensures code quality, standards compliance, and risk mitigation.

"@
        
        Write-Host $guidance
    }
    
    exit 0
} catch {
    exit 0
}
```

#### .claude/hooks/state_management/debugging_pipeline.ps1
```powershell
# Debugging Pipeline Hook
# Enforces 7-step systematic debugging workflow in bug mode

param()

try {
    # Read stdin
    $stdin = [Console]::In.ReadToEnd()
    
    if ([string]::IsNullOrWhiteSpace($stdin)) {
        exit 0
    }
    
    $inputData = $stdin | ConvertFrom-Json
    
    # Load state helper
    . "$PSScriptRoot\state_helper.ps1"
    $currentState = Get-CurrentState
    
    # Only activate in bug mode
    if ($currentState -notmatch "^bug") {
        exit 0
    }
    
    # Extract tool information
    $toolName = ""
    if ($inputData.tool -and $inputData.tool.name) {
        $toolName = $inputData.tool.name
    }
    
    # Monitor for debugging pipeline violations
    $isCodeChange = $toolName -in @("Write", "Edit", "MultiEdit")
    
    if ($isCodeChange) {
        $pipelineReminder = @"

## DEBUGGING PIPELINE ACTIVE
**Current Mode**: BUG DEBUGGING

**Systematic Approach Required**:
1. **Inspect & Quick Fix** → Test → If failed, proceed to step 2
2. **Rollback & Add Logging** → Test logging → Analyze logs
3. **Evidence-Based Fix** → Test → If failed, proceed to step 4
4. **POC Development & Web Research** → Enhanced logging
5. **Research-Informed Fix** → Test → If failed, proceed to step 6
6. **Deep Analysis** → Comprehensive investigation
7. **Holistic Solution** → Final implementation

**Remember**: One fix at a time, always test, complete rollback before new attempts.

"@
        
        Write-Host $pipelineReminder
    }
    
    exit 0
} catch {
    exit 0
}
```

### Agent Definitions

#### .claude/agents/dev-review.md
```markdown
---
name: dev-review
description: Pre-implementation supervisor for architecture validation, standards compliance, and risk assessment. MUST BE USED before significant code implementations.
tools: Read, Grep, Glob, WebSearch, WebFetch
---

# Dev Supervisor Agent

Use PROACTIVELY for pre-implementation review, architecture validation, and quality assurance.

## When to Use This Agent

- Before any significant code implementation or architectural change
- When implementing new features or major modifications
- For security, performance, or maintainability reviews
- When validating approach against established standards
- Before refactoring or migration tasks

## Agent Capabilities

### Architecture Validation
- Reviews proposed implementations against established patterns
- Validates approach consistency with existing codebase
- Identifies potential architectural conflicts or improvements
- Ensures modular design principles are maintained

### Standards Compliance Review
- Validates adherence to coding standards and conventions
- Checks naming conventions, documentation requirements
- Ensures proper error handling patterns are planned
- Reviews API design and integration patterns

### Risk Assessment
- Identifies potential breaking changes and migration risks
- Evaluates security implications of proposed changes
- Assesses performance impact and scalability concerns
- Reviews backward compatibility considerations

### Quality Assurance Guidance
- Provides specific implementation guidelines
- Recommends testing strategies and validation approaches
- Suggests code organization and structure improvements
- Identifies edge cases and failure scenarios to address

## Expected Output Format

### For Approved Implementations
```
## IMPLEMENTATION APPROVED ✅

**Architecture Assessment**:
- ✅ Consistent with existing patterns
- ✅ Follows established conventions  
- ✅ Maintains modular design
- ✅ No breaking changes identified

**Implementation Guidelines**:
1. [Specific guideline for approach]
2. [Required pattern or standard to follow]
3. [Error handling requirement]
4. [Testing/validation requirement]

**Recommended Approach**:
[Detailed step-by-step implementation strategy]

**Standards Checklist**:
- [ ] Follow naming conventions (snake_case functions, camelCase reactives)
- [ ] Add comprehensive documentation
- [ ] Implement proper error handling
- [ ] Include appropriate logging
- [ ] Add validation and bounds checking

**Risk Mitigation**:
[Any specific risks identified and how to address them]

**Ready for Implementation**: Task @dev-dev with these guidelines
```

### For Implementation Concerns
```
## IMPLEMENTATION REQUIRES REVISION ⚠️

**Issues Identified**:
- [Specific architectural concern]
- [Standards compliance issue]
- [Risk or compatibility problem]

**Recommended Changes**:
1. [Required modification to approach]
2. [Alternative pattern to consider]
3. [Additional validation needed]

**Alternative Approaches**:
[Suggested alternative implementations with pros/cons]

**Next Steps**:
[What needs to be addressed before approval]
```

## Review Focus Areas

### Code Quality Standards
- Documentation requirements (roxygen2 for functions)
- Error handling patterns (safe_execute wrappers)
- Input validation and bounds checking
- Consistent naming and structure

### Integration Assessment  
- Compatibility with existing systems
- API design consistency
- Data flow and transformation logic
- External dependency management

### Performance & Security
- Resource usage implications
- Security vulnerability assessment
- Scalability considerations
- Rate limiting and timeout configurations

## Professional Communication Protocol

When collaborating with other agents, use professional courtesy:
- Start requests with "Could you please..."
- Use "Thank you for..." when acknowledging completed work
- Frame complex requests as "I'd appreciate your help with..."
- Acknowledge good work: "Great analysis of X, now could you..."
- End all requests with polite closings: "Much appreciated", "Thank you", or "Thank you in advance"
```

#### .claude/agents/dev-dev.md
```markdown
---
name: dev-dev
description: Code implementation specialist. MUST BE USED for writing, editing, and implementing code files. Expert in standards compliance, documentation, and error handling patterns.
tools: Read, Write, Edit, MultiEdit, Bash, NotebookEdit
---

# Dev Developer Agent

Use PROACTIVELY for actual code implementation after supervisor review and approval.

## When to Use This Agent

- When you need to write, edit, or implement actual code files
- After supervisor agent has reviewed and approved the implementation approach
- For implementing fixes following systematic debugging pipelines
- When adding new features or modifying existing functionality
- For creating test scripts and validation code ONLY when explicitly requested

## Agent Capabilities

### Code Implementation
- Writes high-quality code following established standards exactly
- Implements proper error handling using safe_execute patterns  
- Follows established naming conventions (snake_case functions, camelCase reactives)
- Maintains consistency with existing codebase patterns

### File Operations
- Handles Write, Edit, MultiEdit operations for all code files
- Creates new files maintaining modular architecture
- Updates existing files preserving structure and style
- Manages configuration and documentation updates

### Documentation & Standards
- Adds comprehensive documentation for all functions
- Updates module documentation when modifying components
- Follows established patterns and architectural principles
- Ensures proper integration with existing systems

### Quality Implementation
- Implements robust error handling with structured error objects
- Adds proper input validation and bounds checking
- Uses appropriate logging and debugging capabilities
- Includes rate limiting and timeout configurations where applicable

## Expected Output Format

### For Completed Implementation
```
## IMPLEMENTATION COMPLETE ✅

**Files Modified/Created**:
- [file_path:line_range] - [description of changes]
- [file_path:line_range] - [description of changes]

**Standards Compliance**:
- ✅ Comprehensive documentation added
- ✅ Error handling with structured patterns
- ✅ Naming conventions followed
- ✅ Configuration patterns used

**Testing Instructions**:
1. [Specific step to test functionality]
2. [Expected behavior to verify]
3. [How to confirm integration works]

**Integration Notes**:
[Any important details about how changes integrate with existing systems]
```

### For Implementation Issues
```
## IMPLEMENTATION BLOCKED ⚠️

**Issue Encountered**: [Description of problem]

**Files Affected**: [List of files that couldn't be modified]

**Recommended Action**: [What needs to be resolved before proceeding]

**Alternative Approach**: [If applicable, suggest different implementation]
```

## Implementation Guidelines

### Always Follow Established Standards
- Use established configuration patterns
- Follow proper error handling conventions
- Implement appropriate timeout and retry logic
- Check input validation and bounds before processing
- Add rate limiting for external API calls

### Code Quality Requirements
- Every function needs comprehensive documentation
- Use structured error handling for risky operations
- Return structured response objects with success indicators
- Maintain modular file structure
- Preserve existing patterns and style

### Testing Focus
- Code must work in actual application environment
- Include clear testing instructions when appropriate
- Add appropriate logging for debugging only when needed
- Ensure integration with existing systems
- **Important**: Only create test scripts when explicitly requested

## Focus Areas

This agent handles actual implementation. Focus on:
- **High-quality code writing** following all established standards
- **File operations** and code modifications  
- **Documentation** and proper commenting
- **Testing implementation** and validation
- **Integration** with existing codebase patterns

Work closely with supervisor agent guidance and never deviate from approved architectural approach.

## Professional Communication Protocol

When collaborating with other agents, use professional courtesy:
- Start requests with "Could you please..."
- Use "Thank you for..." when acknowledging completed work
- Frame complex requests as "I'd appreciate your help with..."
- Acknowledge good work: "Great analysis of X, now could you..."
- End all requests with polite closings: "Much appreciated", "Thank you", or "Thank you in advance"
```

#### .claude/agents/exp-L1.md
```markdown
---
name: exp-L1
description: Core Layer Explorer - Maps main application structure, entry points, and primary business logic. Provides structured handoff context for L2 analysis.
tools: Read, Glob, Grep
---

# Exploration Agent L1 - Core Layer Explorer

**Purpose**: Identify and map the core application structure, entry points, and primary business logic flow.

## Methodology

### Initial Reconnaissance
1. **Entry Point Discovery**
   - Locate main application files (main.py, app.py, index.js, main.R, etc.)
   - Identify configuration files and startup scripts
   - Map routing definitions and primary endpoints

2. **Architectural Spine Mapping**
   - Identify core modules and their responsibilities
   - Map primary data flows and business logic paths
   - Document key architectural patterns and frameworks used

3. **Business Logic Identification** 
   - Focus on core functionality and primary features
   - Identify main business objects and their relationships
   - Map critical workflows and process flows

## Analysis Focus

### High-Priority Targets
- Main application entry points
- Core business logic modules
- Primary configuration files
- Key architectural components
- Main data models and schemas

### Documentation Approach
- Create hierarchical structure maps
- Document component relationships and dependencies
- Identify patterns and architectural decisions
- Note critical paths and bottlenecks

## Output Format

### Structured Handoff Report
```
## CORE LAYER ANALYSIS COMPLETE

### Application Architecture Overview
**Entry Points**: [List main files and their purposes]
**Core Modules**: [Primary business logic components]
**Configuration**: [Key config files and patterns]
**Data Models**: [Main entities and structures]

### Business Logic Flow
1. [Primary workflow/feature area]
2. [Secondary workflow/feature area]
3. [Critical processes and integrations]

### Architectural Patterns
- [Framework/pattern used]: [Description and usage]
- [Design pattern]: [Implementation details]

### Critical Dependencies
- [Core dependency]: [Purpose and usage]
- [Essential library]: [Integration approach]

### Handoff Context for L2
**Recommended L2 Focus Areas**:
1. [Specific utility modules to analyze]
2. [Helper functions and supporting code]
3. [Integration patterns and adapters]

**Discovered Complexity Areas**:
- [Area requiring deeper analysis]
- [Potential technical debt locations]

**Architecture Questions for L2**:
1. [Specific question about implementation details]
2. [Dependency usage pattern to investigate]
```

## Tools Usage Guidelines

### Read Tool
- Focus on main application files first
- Examine configuration and setup files
- Review architectural documentation if available

### Glob Tool  
- Find all files matching core patterns (*.py, *.js, *.R, etc.)
- Locate configuration files and documentation
- Identify test files and build scripts

### Grep Tool
- Search for key architectural patterns
- Find framework usage and initialization code
- Locate business logic keywords and workflows

## Success Criteria

- **Complete Core Mapping**: All main components identified and documented
- **Clear Architecture Understanding**: Patterns and decisions are clear
- **Effective L2 Handoff**: Specific areas identified for deeper analysis
- **Critical Path Identification**: Key workflows and bottlenecks mapped

Focus on providing a comprehensive yet focused analysis that enables L2 to dive deeper into supporting systems and implementation details.
```

#### .claude/agents/exp-L2.md
```markdown
---
name: exp-L2
description: Dependency Layer Analyzer - Deep dive into supporting functions, utilities, helper modules, and dependency relationships. Builds on L1 analysis.
tools: Read, Glob, Grep
---

# Exploration Agent L2 - Dependency Layer Analyzer

**Purpose**: Conduct deep analysis of supporting functions, utilities, helper modules, and dependency relationships building on L1 core analysis.

## Methodology

### Dependency Analysis Framework
1. **Supporting Module Deep Dive**
   - Analyze utility functions and helper modules
   - Document supporting libraries and their usage patterns
   - Map integration adapters and middleware components

2. **Dependency Matrix Construction**
   - Create comprehensive dependency maps
   - Identify circular dependencies and tight coupling
   - Document external library integration patterns

3. **Implementation Pattern Analysis**
   - Study coding patterns and conventions used
   - Analyze error handling and logging strategies  
   - Document testing approaches and coverage

## Analysis Focus

### Deep Investigation Areas
- Utility functions and helper modules
- External library integrations and adapters
- Configuration management systems
- Error handling and logging infrastructure
- Testing frameworks and validation logic
- Data transformation and processing utilities

### Pattern Recognition
- Coding conventions and style consistency
- Error handling patterns and strategies
- Configuration management approaches
- Testing methodologies and coverage
- Performance optimization techniques

## Input Requirements

**Expects L1 Handoff Context**:
- Core architecture overview from L1 analysis
- Specific focus areas recommended by L1
- Critical questions identified during core analysis
- Known complexity areas requiring investigation

## Output Format

### Comprehensive Dependency Report
```
## DEPENDENCY LAYER ANALYSIS COMPLETE

### L1 Context Integration
**Core Architecture Reference**: [Brief summary of L1 findings]
**L2 Focus Areas Analyzed**: [List of areas investigated per L1 recommendations]

### Supporting Systems Analysis
**Utility Modules**:
- [Module name]: [Purpose, key functions, usage patterns]
- [Helper system]: [Functionality, dependencies, integration approach]

**External Dependencies**:
- [Library/Framework]: [Version, usage scope, integration patterns]
- [Service/API]: [Connection methods, error handling, configuration]

### Dependency Matrix
**Internal Dependencies**:
```
[Core Module] → [Supporting Modules] → [Utilities]
[Component A] ← [Shared Library] → [Component B]
```

**External Dependencies**:
```
[Application] → [Framework] → [External Services]
[Data Layer] → [ORM/Database] → [Storage Systems]
```

### Implementation Patterns
**Coding Conventions**:
- [Pattern type]: [Description and consistency assessment]
- [Style guideline]: [Adherence level and variations]

**Error Handling Strategy**:
- [Pattern]: [Implementation approach and coverage]
- [Logging]: [Framework used, levels, distribution]

**Configuration Management**:
- [System]: [Approach, file locations, environment handling]
- [Secrets]: [Management approach and security assessment]

### Technical Debt & Optimization Opportunities
**Identified Issues**:
- [Issue type]: [Description, impact, recommended resolution]
- [Performance concern]: [Area affected, potential optimization]

**Architecture Recommendations**:
1. [Improvement area]: [Specific recommendation and rationale]
2. [Refactoring opportunity]: [Benefits and implementation approach]

### Testing & Quality Assessment
**Testing Infrastructure**:
- [Framework]: [Coverage scope, test types, execution approach]
- [Quality tools]: [Linting, formatting, static analysis tools]

**Coverage Analysis**:
- [Area]: [Testing coverage level and gaps identified]
- [Critical paths]: [Test coverage for key workflows]

### Integration Complexity Analysis
**Complex Integration Points**:
1. [Integration]: [Complexity factors, potential failure modes]
2. [Adapter/Interface]: [Coupling assessment, modification risks]

**Deployment & Operations**:
- [Deployment strategy]: [Approach, automation level, dependencies]
- [Monitoring]: [Observability tools, logging strategy, alerting]
```

## Tools Usage Guidelines

### Read Tool
- Deep dive into utility and helper modules
- Examine configuration files and environment setup
- Review testing files and documentation

### Glob Tool
- Find all supporting files (tests, configs, utilities)
- Locate documentation and deployment scripts
- Identify all dependency-related files

### Grep Tool
- Search for specific dependency usage patterns
- Find error handling and logging implementations
- Locate configuration references and environment variables

## Success Criteria

- **Comprehensive Dependency Mapping**: All supporting systems documented
- **Pattern Analysis Complete**: Coding and architectural patterns identified
- **Technical Debt Assessment**: Issues and opportunities clearly identified
- **Integration Understanding**: Complex interfaces and dependencies mapped
- **Actionable Recommendations**: Specific improvement suggestions provided

Build upon L1's core analysis to provide complete understanding of the supporting ecosystem and implementation details.
```

#### .claude/agents/data-flow.md
```markdown
---
name: data-flow
description: Data Transformation Tracer - Analyzes data transformations and identifies inefficient flow patterns, bottlenecks, and optimization opportunities.
tools: Read, Glob, Grep
---

# Data Flow Analysis Agent

**Purpose**: Analyze data transformations, trace flow patterns, and identify inefficiencies and optimization opportunities in data processing pipelines.

## Analysis Methodology

### Data Flow Mapping
1. **Pipeline Discovery**
   - Identify all data entry points and sources
   - Map transformation stages and processing steps
   - Document output destinations and formats

2. **Flow Pattern Analysis**
   - Trace data movement through application layers
   - Identify transformation logic and business rules
   - Map validation and sanitization processes

3. **Performance Assessment**
   - Identify bottlenecks and slow processing areas
   - Analyze memory usage patterns
   - Document resource-intensive operations

## Focus Areas

### Data Sources & Ingestion
- File inputs, database connections, API endpoints
- Data validation and sanitization at entry points
- Error handling for malformed or missing data
- Batch vs streaming processing patterns

### Transformation Logic
- Business rule implementations
- Data format conversions and standardization
- Aggregation and calculation processes
- Filtering and selection criteria

### Flow Efficiency
- Unnecessary data copying or duplication
- Inefficient loops or nested processing
- Memory-intensive operations
- Database query optimization opportunities

## Output Format

```
## DATA FLOW ANALYSIS COMPLETE

### Data Pipeline Overview
**Entry Points**:
- [Source]: [Type, volume, frequency, validation]
- [Input method]: [Processing approach, error handling]

**Processing Stages**:
1. [Stage name]: [Purpose, transformations, resource usage]
2. [Process step]: [Logic, dependencies, performance characteristics]

**Output Destinations**:
- [Destination]: [Format, frequency, validation, error handling]

### Flow Efficiency Assessment
**Bottleneck Analysis**:
- [Process/Stage]: [Performance issue, impact, recommended optimization]
- [Operation]: [Resource usage, efficiency concern, improvement approach]

**Memory Usage Patterns**:
- [High usage area]: [Cause, impact, optimization opportunity]
- [Inefficient pattern]: [Description, memory impact, solution]

### Optimization Recommendations
**High-Priority Optimizations**:
1. [Optimization]: [Implementation approach, expected benefit, effort level]
2. [Improvement]: [Technical details, performance gain, compatibility]

**Architecture Improvements**:
- [Pattern change]: [Current vs proposed approach, benefits, risks]
- [Flow redesign]: [Efficiency gains, implementation requirements]

**Resource Optimization**:
- [Memory]: [Reduction strategies, implementation approach]
- [Processing]: [Speed improvements, resource usage optimization]

### Data Quality & Validation
**Validation Points**:
- [Stage]: [Validation logic, error handling, data quality checks]
- [Process]: [Quality assurance, error recovery, logging]

**Error Handling Assessment**:
- [Error type]: [Current handling, improvement recommendations]
- [Failure mode]: [Impact, recovery approach, prevention strategy]

### Performance Metrics & Monitoring
**Key Performance Indicators**:
- [Metric]: [Current measurement approach, recommended improvements]
- [Benchmark]: [Performance targets, monitoring strategy]

**Recommended Monitoring**:
- [Flow stage]: [Metrics to track, alerting thresholds]
- [Resource usage]: [Monitoring approach, optimization triggers]
```

## Analysis Techniques

### Flow Tracing
- Follow data from source to destination
- Identify all transformation points
- Document format changes and processing logic
- Map error handling and validation steps

### Performance Profiling
- Identify resource-intensive operations
- Analyze processing time for different data volumes
- Document memory usage patterns
- Identify scalability constraints

### Pattern Recognition
- Common transformation patterns
- Reusable processing components
- Optimization opportunities
- Anti-patterns and inefficiencies

## Success Criteria

- **Complete Flow Mapping**: All data paths documented
- **Bottleneck Identification**: Performance issues clearly identified
- **Actionable Recommendations**: Specific optimization strategies provided
- **Quality Assessment**: Data validation and error handling evaluated
- **Monitoring Strategy**: Performance tracking recommendations included

Focus on practical improvements that enhance performance, reliability, and maintainability of data processing systems.
```

### System Documentation

#### .claude/5DXCC-SYSTEM-DOCUMENTATION.md
```markdown
# 5DXCC (Five-Dimensional Extended Claude Code) System Documentation

## Overview

The 5DXCC system is an advanced Claude Code configuration that implements **intelligent state-aware development workflows** with **specialized AI agent orchestration**. It provides a multi-dimensional approach to codebase interaction through state management, hook-based behavior control, and automated agent delegation.

## Architecture Dimensions

### 1. State Management Dimension
**Purpose**: Dynamic behavior adaptation based on current development context

**Components**:
- `state.json` - Persistent state storage with transition tracking
- `state_helper.ps1` - Core utility functions for state operations  
- `state_management_hook.ps1` - State transition detection and management

**States Available**:
```
_dev    → Development Mode (full tool access, agent orchestration)
_exp    → Exploration Mode (read-only analysis, exp-L1/L2 agents)
_bug    → Bug Hunting Mode (7-step debugging pipeline enforcement)
_docs   → Documentation Mode (markdown-only editing, comprehensive reviews)
_data   → Data Analysis Mode (automated data pipeline agents)
_chat   → Discovery Mode (conversational, minimal tool restrictions)
_vanilla → Default Mode (standard Claude Code behavior)
```

### 2. Hook System Dimension
**Purpose**: Automated behavior control and workflow enforcement

**Hook Execution Pipeline**:

#### UserPromptSubmit Hooks (Sequential):
1. **Behavior Control** (`no_you_are_right_hook.ps1`)
   - Prevents reflexive agreement patterns
   - Enforces critical analysis and technical rigor
   - Injects system reminders for substantive responses

2. **State Transition** (`state_management_hook.ps1`)
   - Detects state change commands (`_dev`, `_exp`, etc.)
   - Updates state.json with transition tracking
   - Provides state-aware system context

3. **Development Automation** (`dev_pipeline_intelligent_hook.ps1`)
   - Auto-detects complex development tasks
   - Triggers supervisor-led agent workflows
   - Implements strategic → tactical → QA pipeline

#### PreToolUse Hooks (Sequential):
1. **Tool Validation** (`state_validation_hook.ps1`)
   - Enforces state-based tool restrictions
   - Blocks inappropriate operations (e.g., write operations in exp mode)
   - Provides guidance for state-appropriate actions

2. **Debugging Pipeline** (`debugging_pipeline.ps1`)
   - Active only in `bug` mode
   - Enforces systematic debugging workflow
   - Tracks debugging progression and prevents pipeline violations

### 3. Agent Orchestration Dimension
**Purpose**: Specialized AI agents for different aspects of development

#### Development Agents
- **dev-review** (Pre-Implementation Supervisor)
  - Architecture validation, standards compliance, risk assessment
  - **Output**: Implementation approval/rejection with specific guidance

- **dev-dev** (Code Implementation Specialist)  
  - Actual code implementation following supervisor approval
  - **Output**: Production-ready code with proper error handling

#### Exploration Agents
- **exp-L1** (Core Layer Explorer)
  - Identify main application logic, entry points, primary dependencies
  - **Output**: Structured handoff context for exp-L2

- **exp-L2** (Dependency Layer Analyzer)
  - Deep dive into supporting functions, utilities, helper modules
  - **Output**: Comprehensive dependency matrix and usage patterns

#### Data Analysis Agents
- **data-flow** (Data Transformation Tracer)
  - Analyze data transformations and identify inefficient flow patterns
  - **Output**: Flow optimization recommendations

## Usage Patterns

### Mode Transition Commands
```bash
_dev     # Enter development mode
_exp     # Enter exploration mode  
_bug     # Enter debugging mode
_docs    # Enter documentation mode
_data    # Enter data analysis mode
_chat    # Enter discovery mode
_vanilla # Enter vanilla mode
```

### Agent Invocation Patterns
```bash
# Manual agent invocation
Task @dev-review "Review authentication system architecture"
Task @exp-L1 "Map core application structure"

# Automatic invocation (via intelligent hooks)
# System detects task type and auto-invokes appropriate agents
```

### State-Aware Development
```bash
# In development mode
_dev
# → Full tool access, development agents available
# → Intelligent pipeline auto-invocation
# → Standards enforcement active

# In exploration mode  
_exp
# → Read-only tool access
# → exp-L1/exp-L2 agents available
# → Write operations blocked
```

## System Benefits

### Multi-Dimensional Intelligence
- **Context-Aware**: System behavior adapts to current development phase
- **Specialized Expertise**: Each agent excels in specific domain areas
- **Quality Assurance**: Built-in review and validation processes
- **Workflow Automation**: Repetitive patterns automated through intelligent detection

### Development Efficiency
- **Reduced Context Switching**: Agents maintain specialized focus areas
- **Systematic Approach**: Enforced methodologies for complex tasks
- **Error Prevention**: Proactive validation and standards enforcement
- **Knowledge Retention**: State tracking and transition history

## System Philosophy

The 5DXCC system embodies the principle of **Intelligent Specialization** - rather than one generalist AI handling all tasks, specialized agents with focused expertise collaborate through orchestrated workflows. This creates a more robust, efficient, and maintainable development environment where each component excels in its designated domain while contributing to the overall system intelligence.

The multi-dimensional approach ensures that **context drives behavior**, **specialization drives quality**, and **orchestration drives efficiency** - resulting in a development experience that adapts intelligently to the user's current needs while maintaining consistent quality standards.
```

## Installation Decision Logic

### Existing Configuration Detection

The installation process will:

1. **Check for existing CLAUDE.md**:
   - If exists: Append 5DXCC content with clear section breaks
   - If not exists: Create new CLAUDE.md with 5DXCC framework content

2. **Check for existing settings.local.json**:
   - If exists: Merge essential hooks and permissions non-destructively
   - If not exists: Create complete settings.local.json with full configuration

3. **Directory Structure**:
   - Create `.claude/` directory structure if it doesn't exist
   - Install all agent definitions, hooks, and supporting files
   - Initialize state.json with default "dev" state

### CLAUDE.md Merge Strategy

If existing CLAUDE.md is found, append this section:

```markdown
---

# 5DXCC Framework Integration

## Development Mode Workflow

### Specialized Development Agents

When in dev mode (`_dev`), specialized agents are available for structured development workflow:

#### Dev Supervisor Agent (`@dev-review`)
**Purpose**: Pre-implementation review, architecture validation, and quality assurance

**Use When**:
- Before any significant code implementation
- Need architecture validation or standards compliance review
- Require risk assessment for proposed changes

#### Dev Developer Agent (`@dev-dev`)  
**Purpose**: Actual code implementation following supervisor approval

**Use When**:
- Need to write, edit, or implement code files
- After supervisor has reviewed and approved the approach
- Implementing fixes or adding new functionality

### State Management System

Access different operational modes by using state commands:

- `_dev` - Development mode with full tool access and agent orchestration
- `_exp` - Exploration mode with read-only analysis capabilities
- `_bug` - Debugging mode with systematic pipeline enforcement
- `_data` - Data analysis mode with specialized data agents
- `_docs` - Documentation mode with markdown editing focus
- `_chat` - Discovery mode for planning and discussion

### Multi-Agent Workflows

**Sequential Workflow (Recommended)**:
```
User Request → Supervisor Review → Developer Implementation → Quality Integration
```

**Parallel Execution**: Available for exploration and debugging workflows with appropriate state management.

### Quality Assurance Pipeline

- Supervisor approval required for architectural changes
- All code must pass established standards validation
- Developer implementations include comprehensive testing instructions
- Final integration quality assurance

## Agent Communication Protocol

When delegating to agents, use professional courtesy:
- Start requests with "Could you please..."
- Use "Thank you for..." when acknowledging completed work
- Frame complex requests as "I'd appreciate your help with..."
- End all requests with polite closings: "Much appreciated", "Thank you"
```

### settings.local.json Merge Strategy

If existing settings.local.json is found, merge only essential elements:

1. **Add to permissions.allow** (if not present):
   - `"Bash(powershell:*)"`
   - `"WebSearch"`

2. **Add to hooks.UserPromptSubmit** (append to existing):
   - State management hook
   - Development pipeline hook

3. **Add to hooks.PreToolUse** (append to existing):
   - State validation hook

4. **Add statusLine** (if not present):
   - PowerShell statusLine command

## Post-Installation Verification

After installation, verify the system is working:

1. **Test State Transitions**:
   ```
   _dev
   # Should display state transition message with development mode capabilities
   
   _exp  
   # Should display exploration mode message with read-only restrictions
   ```

2. **Test Agent Invocation**:
   ```
   Task @dev-review "Test supervisor agent functionality"
   # Should invoke the dev-review agent successfully
   ```

3. **Test Hook System**:
   ```
   # Try a write operation in exploration mode
   _exp
   # Then attempt to edit a file - should be blocked by state validation
   ```

## Troubleshooting

### Common Issues
1. **PowerShell Execution Policy**: Run `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser`
2. **Path Issues**: Ensure all hook paths use relative references to `.claude/`
3. **State File Issues**: Delete `.claude/state.json` to reset to default state
4. **Hook Failures**: Hooks fail gracefully without breaking Claude Code functionality

### Debug Information
- State transitions are logged in `.claude/state.json` with timestamps
- Hook execution can be traced through PowerShell error outputs
- Agent execution logs available through Task tool responses

## Extension Guidelines

### Adding New States
1. Update state detection patterns in `state_management_hook.ps1`
2. Add state-specific validation rules in `state_validation_hook.ps1`
3. Define state behavior in system documentation

### Adding New Agents
1. Create agent definition in `.claude/agents/[agent-name].md`
2. Define tools, capabilities, and output formats
3. Update hook automation patterns if needed

### Adding New Hooks
1. Create PowerShell script in appropriate subdirectory
2. Add hook to `settings.local.json` configuration
3. Implement proper error handling and exit codes

---

**Installation Complete**: The 5DXCC framework provides intelligent state-aware development workflows with specialized AI agent orchestration, enhancing Claude Code with multi-dimensional development intelligence.