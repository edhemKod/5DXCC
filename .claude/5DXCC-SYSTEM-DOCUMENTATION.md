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

4. **Data Pipeline Automation** (`data_pipeline_auto_hook.ps1`)
   - Detects data analysis requirements
   - Auto-invokes specialized data agents
   - Coordinates data-flow → data-struct → data-api sequence

#### PreToolUse Hooks (Sequential):
1. **Tool Validation** (`state_validation_hook.ps1`)
   - Enforces state-based tool restrictions
   - Blocks inappropriate operations (e.g., write operations in exp mode)
   - Provides guidance for state-appropriate actions

2. **Debugging Pipeline** (`debugging_pipeline.ps1`)
   - Active only in `bug` mode
   - Enforces 7-step systematic debugging workflow
   - Tracks debugging progression and prevents pipeline violations

### 3. Agent Orchestration Dimension
**Purpose**: Specialized AI agents for different aspects of development

#### Exploration Agents
- **exp-L1** (Core Layer Explorer)
  - **Tools**: Read, Glob, Grep
  - **Purpose**: Identify main application logic, entry points, primary dependencies
  - **Methodology**: Architectural spine mapping, business logic identification
  - **Output**: Structured handoff context for exp-L2

- **exp-L2** (Dependency Layer Analyzer)
  - **Tools**: Read, Glob, Grep
  - **Purpose**: Deep dive into supporting functions, utilities, helper modules
  - **Methodology**: Dependency analysis, utility function categorization
  - **Output**: Comprehensive dependency matrix and usage patterns

#### Development Agents
- **dev-review** (Pre-Implementation Supervisor)
  - **Tools**: Read, Grep, Glob, WebSearch, WebFetch
  - **Purpose**: Architecture validation, standards compliance, risk assessment
  - **Methodology**: CLAUDE.md standards verification, quality assurance
  - **Output**: Implementation approval/rejection with specific guidance

- **dev-dev** (Code Implementation Specialist)
  - **Tools**: Read, Write, Edit, MultiEdit, Bash, NotebookEdit
  - **Purpose**: Actual code implementation following supervisor approval
  - **Methodology**: Standards-compliant code generation, comprehensive documentation
  - **Output**: Production-ready code with proper error handling and tests

#### Data Analysis Agents
- **data-flow** (Data Transformation Tracer)
  - **Tools**: Read, Glob, Grep
  - **Purpose**: Analyze data transformations and identify inefficient flow patterns
  - **Methodology**: Pipeline analysis, bottleneck identification
  - **Output**: Flow optimization recommendations

- **data-struct** (Data Structure Evaluator)
  - **Tools**: Read, Glob, Grep
  - **Purpose**: Evaluate data structure choices and memory efficiency
  - **Methodology**: Structure analysis, memory usage optimization
  - **Output**: Structure improvement recommendations

- **data-api** (API Data Handler)
  - **Tools**: Read, Glob, Grep
  - **Purpose**: Analyze API data handling, validation efficiency, processing optimization
  - **Methodology**: API pattern analysis, validation workflow optimization
  - **Output**: API handling improvements

#### Supporting Agents
- **docs-crawler** (External Knowledge Gatherer)
  - **Tools**: WebSearch, WebFetch
  - **Purpose**: Gather documentation, solutions, community knowledge
  - **Methodology**: Multi-source research, knowledge synthesis
  - **Output**: Consolidated external documentation and solutions

- **think** (Critical Analysis Agent)
  - **Tools**: Read, Grep, Glob, WebSearch
  - **Purpose**: Challenge assumptions, identify edge cases, critical analysis
  - **Methodology**: Systematic assumption testing, edge case identification
  - **Output**: Risk assessments and alternative approaches

### 4. Configuration Dimension
**Purpose**: System behavior control and permission management

**Key Configuration Files**:

#### settings.local.json
```json
{
  "permissions": {
    "allow": ["Bash(powershell:*)", "WebSearch", "Bash(Rscript:*)"],
    "defaultMode": "acceptEdits"
  },
  "hooks": {
    "UserPromptSubmit": [/* Sequential hook chain */],
    "PreToolUse": [/* Validation hook chain */]
  },
  "statusLine": {
    "command": "powershell ... statusline_4dcc.ps1"
  }
}
```

**Security Model**:
- PowerShell execution with controlled script execution
- State-based tool restrictions
- Permission-controlled agent capabilities
- Isolated agent execution environments

### 5. Workflow Orchestration Dimension
**Purpose**: Coordinated multi-agent development workflows

#### Development Workflow Pattern
```
User Request → State Detection → Agent Selection → Execution Pipeline

Development Tasks:
User Input → dev-review (validation) → dev-dev (implementation) → dev-review (QA) → User

Exploration Tasks:
User Input → exp-L1 (core analysis) → exp-L2 (dependency analysis) → User

Data Analysis Tasks:
User Input → data-flow → data-struct → data-api → Consolidated Results → User
```

#### Quality Assurance Pipeline
1. **Pre-Implementation Review** (dev-review agent)
   - Standards compliance checking
   - Architecture validation
   - Risk assessment

2. **Implementation Phase** (dev-dev agent)
   - Code generation following approved patterns
   - Comprehensive documentation
   - Error handling implementation

3. **Post-Implementation QA** (dev-review agent)
   - Code quality verification
   - Standards compliance confirmation
   - Final approval process

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

### Scalability Features
- **Modular Architecture**: Easy addition of new agents and hooks
- **Configuration-Driven**: Behavior modification through settings
- **Extensible Workflows**: New pipeline patterns easily implementable
- **State Persistence**: Session continuity across interactions

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

## Technical Implementation

### Core Utilities (state_helper.ps1)
```powershell
# Primary state management functions
Get-CurrentState([string]$StateFile)     # Read current system state
Set-CurrentState([string]$NewState, [string]$StateFile, [string]$SessionId)  # Update state
```

### Error Handling Philosophy
- **Graceful Degradation**: System continues functioning with hook failures
- **State Fallbacks**: Default to "dev" mode if state cannot be determined
- **Progressive Enhancement**: Base Claude Code works without hooks

### Performance Characteristics
- **Minimal Overhead**: Hooks execute quickly with early exits
- **Cached State Reading**: State file read once per operation
- **Efficient Pattern Matching**: Optimized regex for task detection

## Troubleshooting

### Common Issues
1. **PowerShell Execution Policy**: Requires `-ExecutionPolicy Bypass`
2. **State File Corruption**: System defaults to "dev" mode
3. **Hook Failures**: Individual hooks fail gracefully without system impact
4. **Agent Invocation Issues**: Check tool permissions and agent definitions

### Debug Information
- State transitions logged with timestamps in `state.json`
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

## System Philosophy

The 5DXCC system embodies the principle of **Intelligent Specialization** - rather than one generalist AI handling all tasks, specialized agents with focused expertise collaborate through orchestrated workflows. This creates a more robust, efficient, and maintainable development environment where each component excels in its designated domain while contributing to the overall system intelligence.

The multi-dimensional approach ensures that **context drives behavior**, **specialization drives quality**, and **orchestration drives efficiency** - resulting in a development experience that adapts intelligently to the user's current needs while maintaining consistent quality standards.