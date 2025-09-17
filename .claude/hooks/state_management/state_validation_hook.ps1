# Claude Code State Validation Hook
# Enforces tool usage restrictions based on current JSON state

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
    
    # Get current state from JSON file
    $currentState = Get-CurrentState
    
    # Early exit for vanilla mode - no restrictions
    if ($currentState -eq "vanilla") {
        exit 0
    }
    
    # Get tool information from PreToolUse input format
    $toolName = $inputData.tool_name
    $toolParameters = $inputData.tool_input
    
    # Debug log (disabled in production)
    # Add-Content -Path "$PSScriptRoot\log\validation_debug.log" -Value "[$(Get-Date)] Tool: $toolName, State: $currentState, File: $($toolParameters.file_path)"
    
    # State-based tool restrictions
    $violation = $null
    
    if ($currentState -eq "chat") {
        # CHAT mode restrictions
        if ($toolName -eq "Write" -or $toolName -eq "MultiEdit") {
            $filePath = ""
            if ($toolParameters.file_path) {
                $filePath = $toolParameters.file_path
            }
            
            # Only allow .md files in chat mode
            if ($filePath -and -not $filePath.EndsWith(".md")) {
                $violation = "CHAT MODE: Can only write/edit .md files. Use _dev to enter Development mode for code files."
            }
            
            # Check for development planning files and inject testability requirements
            if ($filePath -and $filePath.EndsWith(".md") -and 
                $filePath -match "(?i)(plan|implementation|development|roadmap|design|phase|milestone|sprint|feature|requirement)") {
                Write-Output @"
<system-reminder>
**DEVELOPMENT PLANNING REQUIREMENTS**

When creating implementation plans, each phase MUST include:

1. **User-Testable Deliverables**: Every phase must produce functionality the user can test in the actual application environment (not just standalone test scripts)

2. **Mandatory Development Stops**: Development MUST stop after each phase completion for user testing and approval before proceeding to the next phase

3. **Clear Testing Instructions**: Provide specific steps for the user to verify functionality in the real app environment

4. **Acceptance Criteria**: Define exactly what "working correctly" looks like for each phase

5. **Rollback Plans**: Include how to undo changes if testing reveals issues

**CRITICAL**: No phase should be considered complete until the user has tested it in the application and confirmed it works as expected.
</system-reminder>
"@
            }
        }
        elseif ($toolName -eq "Edit") {
            $filePath = $toolParameters.file_path
            if ($filePath -and -not $filePath.EndsWith(".md")) {
                $violation = "CHAT MODE: Can only edit .md files. Use _dev to enter Development mode for code files."
            }
            
            # Check for development planning files and inject testability requirements
            if ($filePath -and $filePath.EndsWith(".md") -and 
                $filePath -match "(?i)(plan|implementation|development|roadmap|design|phase|milestone|sprint|feature|requirement)") {
                Write-Output @"
<system-reminder>
**DEVELOPMENT PLANNING REQUIREMENTS**

When editing implementation plans, ensure each phase includes:

1. **User-Testable Deliverables**: Every phase must produce functionality the user can test in the actual application environment (not just standalone test scripts)

2. **Mandatory Development Stops**: Development MUST stop after each phase completion for user testing and approval before proceeding to the next phase

3. **Clear Testing Instructions**: Provide specific steps for the user to verify functionality in the real app environment

4. **Acceptance Criteria**: Define exactly what "working correctly" looks like for each phase

5. **Rollback Plans**: Include how to undo changes if testing reveals issues

**CRITICAL**: No phase should be considered complete until the user has tested it in the application and confirmed it works as expected.
</system-reminder>
"@
            }
        }
        elseif ($toolName -eq "TodoWrite") {
            $violation = "CHAT MODE: TodoWrite not available in planning mode. Use _dev to enter Development mode for task management."
        }
        elseif ($toolName -eq "Bash") {
            $command = $toolParameters.command
            # Allow exploration commands, block code execution
            if ($command -match "(?i)(python|node|npm|Rscript|\.exe)" -and -not $command -match "(?i)(ls|dir|cat|grep|find|git\s+status|git\s+log|git\s+diff)") {
                $violation = "CHAT MODE: Code execution blocked. Bash allowed for exploration only. Use _dev for code execution."
            }
        }
        
        # Task tool validation for chat mode
        if ($toolName -eq "Task") {
            $subagentType = ""
            if ($toolParameters.subagent_type) {
                $subagentType = $toolParameters.subagent_type.ToLower()
            }
            
            # Validate allowed agents
            $allowedAgents = @("general-purpose", "master", "regex-expert")
            if ($subagentType -and $subagentType -notin $allowedAgents) {
                $violation = "CHAT MODE: Task tool restricted to general-purpose, master, and regex-expert agents. Use _dev mode to access development agents."
            } else {
                Write-Output @"
<system-reminder>
**CHAT MODE ACTIVE**
You are in chat mode with limited agent access. Available agents:
- general-purpose: For general analysis and discussion
- master: For coordination and workflow management
- regex-expert: For regex pattern assistance and optimization

For development work, documentation crawling, or specialized analysis, use _dev mode to access all agents.
</system-reminder>
"@
            }
        }
    }
    elseif ($currentState -match "^bug") {
        # BUG mode and substates
        $currentSubstate = ""
        if ($currentState -match "_(.+)$") {
            $currentSubstate = $matches[1]
        }
        
        # Task tool validation for bug mode and substates
        if ($toolName -eq "Task") {
            $subagentType = ""
            if ($toolParameters.subagent_type) {
                $subagentType = $toolParameters.subagent_type.ToLower()
            }
            
            # Substate-specific agent restrictions and guidance
            if ($currentSubstate -eq "understand") {
                # _understand: Full investigation pipeline
                $allowedAgents = @("bug-officer", "exp-L1", "docs-crawler", "docs-elder", "data-flow", "data-struct", "data-api", "think", "general-purpose", "master", "regex-expert")
                if ($subagentType -and $subagentType -notin $allowedAgents) {
                    $violation = "BUG_UNDERSTAND MODE: Task tool restricted to investigation agents (bug-officer, exp-L1, docs-crawler, docs-elder, data-*, think, regex-expert). Use _fix for implementation."
                } else {
                    Write-Output @"
<system-reminder>
**DEBUG INVESTIGATION MODE (_understand)**
Full diagnostic pipeline with investigation specialists:
- bug-officer: Senior debugging coordinator with AUTONOMOUS AUTHORITY to deploy any investigation agent
- exp-L1: Codebase investigation (up to 3 instances)
- docs-crawler: External research and documentation
- data-flow/data-struct/data-api: Data analysis specialists
- think: Assumption challenging - bug-officer has AUTONOMOUS authority to summon
- regex-expert: Regex pattern analysis and optimization

**BUG-OFFICER AUTONOMOUS POWERS**:
✓ Deploy think agent for assumption challenging without user confirmation
✓ Execute parallel multi-agent investigations
✓ Make tactical decisions on specialist deployment
✓ Complete full pipeline without user interruption

Pipeline runs autonomously from start to finish. No user interruption until complete report.
</system-reminder>
"@
                }
            }
            elseif ($currentSubstate -eq "debuglog") {
                # _debuglog: Logging implementation only
                $allowedAgents = @("dev-dev", "general-purpose", "master")
                if ($subagentType -and $subagentType -notin $allowedAgents) {
                    $violation = "BUG_DEBUGLOG MODE: Task tool restricted to implementation agents (dev-dev). Use _understand for investigation."
                } else {
                    Write-Output @"
<system-reminder>
**DEBUG LOGGING MODE (_debuglog)**
Focused logging implementation:
- dev-dev: Implement comprehensive debug logging to dev/logs/
- Target specific components identified in investigation phase
- Add detailed state capture and console logging
</system-reminder>
"@
                }
            }
            elseif ($currentSubstate -eq "fix") {
                # _fix: Fix implementation only
                $allowedAgents = @("dev-dev", "general-purpose", "master")
                if ($subagentType -and $subagentType -notin $allowedAgents) {
                    $violation = "BUG_FIX MODE: Task tool restricted to implementation agents (dev-dev). Use _understand for investigation."
                } else {
                    Write-Output @"
<system-reminder>
**DEBUG FIX MODE (_fix)**
Targeted fix implementation:
- dev-dev: Implement specific fixes based on completed investigation
- Apply single fix at a time following systematic approach
- Preserve existing debug logging
</system-reminder>
"@
                }
            }
            elseif ($currentSubstate -eq "revert") {
                # _revert: Rollback fixes only
                $allowedAgents = @("dev-dev", "general-purpose", "master")
                if ($subagentType -and $subagentType -notin $allowedAgents) {
                    $violation = "BUG_REVERT MODE: Task tool restricted to implementation agents (dev-dev). Use _understand for investigation."
                } else {
                    Write-Output @"
<system-reminder>
**DEBUG REVERT MODE (_revert)**
Surgical rollback of fixes:
- dev-dev: Revert previous fix attempts only
- PRESERVE debug logging (never revert logging)
- Surgical rollback maintaining system stability
</system-reminder>
"@
                }
            }
            else {
                # Main bug mode - allow all agents with pipeline guidance
                Write-Output @"
<system-reminder>
**DEBUG MODE SUBSTATE WORKFLOW**
Available debug substates:
- _understand: Full investigation pipeline with bug-officer coordination
- _debuglog: Implement debug logging with dev-dev
- _fix: Apply fixes with dev-dev (after understanding)
- _revert: Rollback fixes preserving logging

Use substates for precise workflow control. Start with _understand for new issues.
</system-reminder>
"@
            }
        }
    }
    elseif ($currentState -match "^docs") {
        # DOCS mode and substates
        $currentSubstate = ""
        if ($currentState -match "_(.+)$") {
            $currentSubstate = $matches[1]
        }
        
        # File operation restrictions based on substate
        if ($toolName -eq "Write" -or $toolName -eq "MultiEdit") {
            $filePath = ""
            if ($toolParameters.file_path) {
                $filePath = $toolParameters.file_path
            }
            
            if ($currentSubstate -eq "buglog") {
                # _buglog: Allow JSON files in .claude/knowledge/bugs/ directory, and .md files
                if ($filePath -and -not ($filePath.EndsWith(".json") -or $filePath.EndsWith(".md"))) {
                    $violation = "DOCS_BUGLOG MODE: Can only write/edit .json files in .claude/knowledge/bugs/ directory or .md files. Use _dev for code files."
                }
                elseif ($filePath -and $filePath.EndsWith(".json") -and -not $filePath -match "\.claude[\\\/]knowledge[\\\/]bugs[\\\/]") {
                    $violation = "DOCS_BUGLOG MODE: JSON files can only be written in .claude/knowledge/bugs/ directory structure."
                }
            }
            else {
                # Standard docs mode - only .md files
                if ($filePath -and -not $filePath.EndsWith(".md")) {
                    $violation = "DOCS MODE: Can only write/edit .md files. Use _dev to enter Development mode for code files."
                }
            }
        }
        elseif ($toolName -eq "Edit") {
            $filePath = $toolParameters.file_path
            if ($currentSubstate -eq "buglog") {
                # _buglog: Allow JSON files in .claude/knowledge/bugs/ directory, and .md files
                if ($filePath -and -not ($filePath.EndsWith(".json") -or $filePath.EndsWith(".md"))) {
                    $violation = "DOCS_BUGLOG MODE: Can only edit .json files in .claude/knowledge/bugs/ directory or .md files. Use _dev for code files."
                }
                elseif ($filePath -and $filePath.EndsWith(".json") -and -not $filePath -match "\.claude[\\\/]knowledge[\\\/]bugs[\\\/]") {
                    $violation = "DOCS_BUGLOG MODE: JSON files can only be edited in .claude/knowledge/bugs/ directory structure."
                }
            }
            else {
                # Standard docs mode - only .md files
                if ($filePath -and -not $filePath.EndsWith(".md")) {
                    $violation = "DOCS MODE: Can only edit .md files. Use _dev to enter Development mode for code files."
                }
            }
        }
        
        # Task tool validation for docs mode and substates
        if ($toolName -eq "Task") {
            $subagentType = ""
            if ($toolParameters.subagent_type) {
                $subagentType = $toolParameters.subagent_type.ToLower()
            }
            
            if ($currentSubstate -eq "buglog") {
                # _buglog: Allow bug logging specialist
                $allowedAgents = @("docs-buglogger", "general-purpose", "master")
                if ($subagentType -and $subagentType -notin $allowedAgents) {
                    $violation = "DOCS_BUGLOG MODE: Task tool restricted to docs-buglogger, general-purpose, and master agents. Use _dev for development work."
                } else {
                    Write-Output @"
<system-reminder>
**BUG LOGGING MODE (_buglog)**
You have bug logging specialists available:
- docs-buglogger: Analyzes debug sessions and creates structured bug knowledge entries
- general-purpose: For general analysis and coordination
- master: For workflow management and session context

Focus: Post-debug session knowledge archival and organizational learning.
</system-reminder>
"@
                }
            }
            else {
                # Standard docs mode
                $allowedAgents = @("general-purpose", "docs-crawler", "master")
                if ($subagentType -and $subagentType -notin $allowedAgents) {
                    $violation = "DOCS MODE: Task tool restricted to general-purpose, docs-crawler, and master agents. Use _dev mode to access development agents."
                } else {
                    Write-Output @"
<system-reminder>
**DOCUMENTATION MODE ACTIVE**
You have specialized documentation agents available:
- general-purpose: For general analysis and writing
- docs-crawler: For systematic documentation creation and updates
- master: For coordination and workflow management

For development work or specialized analysis, use _dev mode to access all agents.
</system-reminder>
"@
                }
            }
        }
        
        # Encourage systematic documentation approach
        if (($toolName -eq "Write" -or $toolName -eq "Edit" -or $toolName -eq "MultiEdit") -and 
            $toolParameters.file_path -and $toolParameters.file_path.EndsWith("README.md")) {
            
            Write-Output @"
<system-reminder>
**DOCUMENTATION MODE REMINDER**
You are updating a README.md file. Best practices:

1. Use Read/Glob tools to explore the folder structure first
2. Examine key files to understand functionality
3. Create comprehensive, accurate documentation
4. Include file/folder explanations, usage instructions, and examples
5. Update table of contents and cross-references

Consider using TodoWrite to track documentation tasks systematically.
</system-reminder>
"@
        }
    }
    elseif ($currentState -eq "exp") {
        # EXP mode - strict read-only exploration
        if ($toolName -eq "Write" -or $toolName -eq "MultiEdit" -or $toolName -eq "Edit" -or $toolName -eq "TodoWrite") {
            $violation = "EXP MODE: Read-only exploration mode. No edits, writes, or todos allowed. Use Read, Grep, Glob, and Task tools only. Switch to _dev for modifications."
        }
        elseif ($toolName -eq "Bash") {
            $command = $toolParameters.command
            # Only allow safe exploration bash commands
            if (-not ($command -match "(?i)^(ls|dir|cat|tree|find|git\s+(status|log|diff|branch)|grep|rg)" -or 
                     $command -match "(?i)^(pwd|which|where|echo|type|file)" -or
                     $command -match "(?i)^git\s+(rev-parse|show|log)" -or
                     $command -match "(?i)^(head|tail)\s+" -or
                     $command -match "(?i)^wc\s+")) {
                $violation = "EXP MODE: Only safe exploration bash commands allowed (ls, dir, cat, tree, find, git status/log/diff/branch, grep, rg, pwd, which, head, tail, wc). No code execution or modifications."
            }
        }
        
        # Encourage use of specialized agents
        if ($toolName -eq "Task") {
            $subagentType = ""
            if ($toolParameters.subagent_type) {
                $subagentType = $toolParameters.subagent_type.ToLower()
            }
            
            # Validate allowed agents in exploration mode
            $allowedExpAgents = @("exp-L0", "exp-L1", "exp-L2", "think", "general-purpose", "docs-crawler", "master")
            if ($subagentType -and $subagentType -notin $allowedExpAgents) {
                $violation = "EXP MODE: Task tool restricted to exploration agents (exp-L0, exp-L1, exp-L2, think, general-purpose, docs-crawler, master). Use _dev mode to access dev-review and dev-dev agents."
            } else {
                Write-Output @"
<system-reminder>
**EXPLORATION MODE ACTIVE**
You have specialized exploration agents available:
- exp-L0: For initial reconnaissance and delegation strategy
- exp-L1: For main logic and entry points
- exp-L2: For supporting functions and utilities

Consider using these agents for comprehensive codebase analysis.
</system-reminder>
"@
            }
        }
    }
    elseif ($currentState -eq "data") {
        # DATA mode - strict read-only data analysis
        if ($toolName -eq "Write" -or $toolName -eq "MultiEdit" -or $toolName -eq "Edit" -or $toolName -eq "TodoWrite") {
            $violation = "DATA MODE: Read-only data analysis mode. No edits, writes, or todos allowed. Use Read, Grep, Glob, and Task tools only. Switch to _dev for modifications."
        }
        elseif ($toolName -eq "Bash") {
            $command = $toolParameters.command
            # Only allow safe exploration bash commands - same as exp mode
            if (-not ($command -match "(?i)^(ls|dir|cat|tree|find|git\s+(status|log|diff|branch)|grep|rg)" -or 
                     $command -match "(?i)^(pwd|which|where|echo|type|file)" -or
                     $command -match "(?i)^git\s+(rev-parse|show|log)" -or
                     $command -match "(?i)^(head|tail)\s+" -or
                     $command -match "(?i)^wc\s+")) {
                $violation = "DATA MODE: Only safe exploration bash commands allowed (ls, dir, cat, tree, find, git status/log/diff/branch, grep, rg, pwd, which, head, tail, wc). No code execution or modifications."
            }
        }
        
        # Enhanced data analysis agent workflow guidance
        if ($toolName -eq "Task") {
            $subagentType = ""
            if ($toolParameters.subagent_type) {
                $subagentType = $toolParameters.subagent_type.ToLower()
            }
            
            # Validate allowed agents in data analysis mode
            $allowedDataAgents = @("data-flow", "data-struct", "data-api", "general-purpose", "docs-crawler", "master")
            if ($subagentType -and $subagentType -notin $allowedDataAgents) {
                $violation = "DATA MODE: Task tool restricted to data analysis agents (data-flow, data-struct, data-api, general-purpose, docs-crawler, master). Use _dev mode to access development agents."
            } else {
                Write-Output @"
<system-reminder>
**DATA ANALYSIS MODE AGENTS AVAILABLE**

For comprehensive data analysis workflow, use specialized agents in sequence:

- **data-flow**: Data transformation tracing and flow optimization
  Use FIRST to map data pathways, identify transformation bottlenecks, trace inefficiencies
  Focus: Pipeline analysis, data flow mapping, transformation optimization

- **data-struct**: Data structure evaluation and memory optimization  
  Use SECOND to assess data types, memory usage, storage efficiency, structural patterns
  Focus: Memory profiling, data type optimization, structural efficiency analysis

- **data-api**: API data handling and validation optimization
  Use THIRD to optimize API calls, validate responses, improve data exchange efficiency
  Focus: API performance, validation optimization, data exchange enhancement

**Recommended Workflow**:
1. Trace data flow: `Task data-flow "Analyze data transformations for [specific analysis]"`
2. Evaluate structures: `Task data-struct "Assess data types and memory efficiency for [specific analysis]"`
3. Optimize API handling: `Task data-api "Optimize API data validation for [specific analysis]"`
4. Master agent consolidates comprehensive analysis results

This ensures thorough data analysis covering flow, structure, and API optimization.
</system-reminder>
"@
            }
        }
    }
    elseif ($currentState -eq "dev") {
        # DEV mode - provide agent workflow guidance
        if (($toolName -eq "Write" -or $toolName -eq "MultiEdit" -or $toolName -eq "Edit") -and
            $toolParameters.file_path -and -not $toolParameters.file_path.EndsWith(".md")) {
            
            Write-Output @"
<system-reminder>
**INTELLIGENT DEVELOPMENT MODE ACTIVE**

Enhanced supervisor-led development workflow with tactical execution:

- **dev-review**: Strategic Planning & Quality Assurance Technical Lead
  PHASE 1: Analyzes requirements, creates tactical plans, determines team size (1-3 agents)
  PHASE 3: Reviews all implementation work, validates against requirements, signs off

- **dev-dev**: Specialized Implementation Agent (1-3 instances based on complexity)
  PHASE 2: Executes specific implementation tasks as planned by supervisor
  Works in parallel or sequential based on tactical decisions

**Intelligent Workflow**:
1. **Strategic Planning**: Supervisor analyzes complexity and creates execution plan
2. **Tactical Execution**: 1-3 dev agents execute work (parallel/sequential as planned)
3. **Quality Assurance**: Supervisor reviews all work and validates integration
4. **User Handoff**: Master agent presents results with testing instructions

**Automatic Activation**: The pipeline auto-detects development tasks and executes the full workflow without user confirmation, adapting team size and execution strategy based on complexity.

This intelligent system ensures optimal resource allocation and strategic alignment.
</system-reminder>
"@
        }
        elseif ($toolName -eq "Task") {
            $subagentType = ""
            if ($toolParameters.subagent_type) {
                $subagentType = $toolParameters.subagent_type
            }
            
            if ($subagentType -eq "dev-review") {
                Write-Output @"
<system-reminder>
**DEV TECHNICAL LEAD AGENT ACTIVE**

This agent serves as Strategic Planning & Quality Assurance Technical Lead:

**PHASE 1 - Strategic Planning:**
- Requirements analysis in context of broader project goals
- Complexity assessment and task breakdown structure
- Tactical decision making: Sprint (parallel) vs Linear vs Hybrid execution
- Team composition: Determine 1-3 dev-dev agents needed and specializations
- Work breakdown with dependencies and integration points
- Quality gates and acceptance criteria definition

**PHASE 3 - Quality Assurance:**
- Review all implementation work against original requirements
- Validate broader project alignment and integration points
- Ensure CLAUDE.md standards compliance and code quality
- Risk mitigation effectiveness assessment
- Sign off on implementation or request specific revisions

Agent acts as Technical Lead making strategic and tactical execution decisions.
</system-reminder>
"@
            }
            elseif ($subagentType -eq "dev-dev") {
                Write-Output @"
<system-reminder>
**DEV DEVELOPER AGENT ACTIVE**

This agent focuses on:
- Actual code implementation following approved approach
- File operations (Write, Edit, MultiEdit) with quality standards
- Roxygen2 documentation and CLAUDE.md compliance
- Testing implementation and integration

Ensure supervisor has approved the approach before implementation.
</system-reminder>
"@
            }
        }
    }
    
    # If violation detected, block the tool use with EXIT CODE 2
    if ($violation) {
        # Use exit code 2 for critical blocking (feeds stderr back to Claude)
        [Console]::Error.WriteLine("BLOCKED: $violation")
        exit 2  # Exit code 2 blocks tool execution
    }
    
    exit 0
}
catch {
    # If anything fails, just exit without blocking
    exit 0
}