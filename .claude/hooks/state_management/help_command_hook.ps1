# 5DXCC Help Command Hook
# Detects _help command and displays system overview
param()

$ErrorActionPreference = "Continue"

try {
    # Read stdin to get user prompt
    $stdin = [Console]::In.ReadToEnd()
    
    if ($stdin) {
        # Handle both JSON and direct text input
        $userPrompt = ""
        try {
            $inputData = $stdin | ConvertFrom-Json
            $userPrompt = $inputData.prompt.trim()
        } catch {
            # If JSON parsing fails, treat as direct text
            $userPrompt = $stdin.trim()
        }
        
        # Check if user requested help
        if ($userPrompt -eq "_help") {
            
            # Inject comprehensive help information as system reminder
            $helpContent = @"

# 5DXCC (Five-Dimensional Extended Claude Code) System

**Intelligent state-aware development workflows with specialized AI agent orchestration**

## Available Modes

**_dev** -> Development Mode (full tool access, agent orchestration)
- **Purpose**: Code implementation, architecture planning, development workflows
- **Agents**: dev-review (pre-implementation validation), dev-dev (code implementation), think (critical analysis), docs-crawler (external knowledge)
- **Features**: Supervisor-led workflows, quality assurance, standards enforcement

**_exp** -> Exploration Mode (read-only analysis)
- **Purpose**: Codebase analysis, architectural understanding, dependency mapping  
- **Agents**: exp-L1 (core architecture), exp-L2 (dependency analysis), think (critical analysis)
- **Features**: Systematic exploration, handoff between L1->L2 agents

**_bug** -> Bug Hunting Mode (systematic debugging)
- **Purpose**: Structured debugging with 7-step pipeline enforcement
- **Agents**: Standard agents with debugging workflow constraints
- **Features**: Rollback tracking, logging implementation, evidence-based fixes

**_docs** -> Documentation Mode (markdown-only editing)
- **Purpose**: Comprehensive documentation review and README updates
- **Agents**: docs-crawler (external knowledge), think (critical analysis)
- **Features**: Mandatory folder review, markdown-only operations

**_data** -> Data Analysis Mode (automated data pipeline)
- **Purpose**: Data flow optimization, structure analysis, API handling
- **Agents**: data-flow (transformation efficiency), data-struct (structure optimization), data-api (API handling), think (critical analysis)
- **Features**: Auto-invoked agent sequence for comprehensive data analysis

**_chat** -> Chat Mode (conversational, minimal restrictions)
- **Purpose**: Discussion, brainstorming, planning conversations
- **Agents**: All agents available but focus on conversational interaction
- **Features**: Codebase familiarization, planning discussions

**_vanilla** -> Vanilla Mode (standard Claude Code behavior)
- **Purpose**: Default Claude Code experience without 5DXCC enhancements
- **Agents**: Standard Claude Code functionality
- **Features**: No specialized workflows or state management

## Specialized Agents Overview

### Development Agents
- **dev-review**: Pre-implementation review, architecture validation, CLAUDE.md standards compliance
- **dev-dev**: Code implementation specialist, roxygen2 documentation, error handling patterns

### Exploration Agents  
- **exp-L1**: Core layer explorer - main application logic, entry points, primary dependencies
- **exp-L2**: Dependency layer analyzer - supporting functions, utilities, helper modules

### Data Analysis Agents
- **data-flow**: Data transformation tracer - identify inefficient flow patterns
- **data-struct**: Data structure evaluator - memory efficiency and structure optimization  
- **data-api**: API data handler - validation efficiency, external data processing

### Supporting Agents
- **docs-crawler**: External knowledge gatherer - documentation, solutions, community knowledge
- **think**: Critical analysis agent - challenge assumptions, identify edge cases

## Usage Patterns

**Mode Switching**: Type mode command (e.g. _dev, _exp, _help)
**Agent Invocation**: Task @agent-name "specific task description"
**Auto-Workflows**: System detects task type and auto-invokes appropriate agents

## Key Features

- **State-Aware Behavior**: Tool restrictions and agent availability based on current mode
- **Quality Assurance**: Built-in review processes and standards enforcement  
- **Workflow Automation**: Intelligent detection and delegation of complex tasks
- **Specialized Expertise**: Each agent excels in specific domain areas
- **Progressive Enhancement**: Works with standard Claude Code, adds intelligence layers

---
*Switch modes anytime with: _help _chat _dev _bug _docs _exp _data _vanilla*

"@

            Write-Host $helpContent
            exit 0
        }
    }
    
    # If not help command, continue normally
    exit 0
    
} catch {
    # If anything fails, just continue without blocking
    exit 0
}