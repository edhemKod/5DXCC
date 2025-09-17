# 5DXCC Framework
## Discovery, Development, Documentation, Debugging, Data analysis, eXploration Claude Code Framework

### TLDR 🚀
Transform Claude Code into an intelligent AI agent orchestration system with automated workflows, specialized agents, and state-aware development pipelines. Just type `_dev`, `_exp`, `_bug`, `_data`, or `_docs` to activate intelligent workflows with automatic agent deployment and quality assurance.

---

### I'm Listening 👂
The 5DXCC Framework is a sophisticated extension for Claude Code that organizes development work into six core operational modes: **Discovery** (_chat), **Development** (_dev), **Documentation** (_docs), **Debugging** (_bug), **Data analysis** (_data), and **eXploration** (_exp). Each mode activates specialized AI agents and automated workflow management. Instead of manually coordinating complex development tasks, the framework automatically detects what you're trying to do and deploys the right combination of expert agents to help you succeed.

**What makes it special:**
- **State-based intelligence**: Different modes (`_dev`, `_exp`, etc.) activate specific workflows and agent teams
- **Autonomous coordination**: Agents automatically collaborate using professional communication protocols
- **Quality assurance**: Built-in supervisor-developer patterns ensure code quality and standards compliance
- **Specialized expertise**: 15 expert agents covering development, debugging, data analysis, exploration, research, and knowledge management

**How it works:**
1. Type a state command (e.g., `_dev`) to activate a development mode
2. The framework automatically detects your task type and complexity
3. Specialized agents are deployed in parallel or sequential workflows
4. Results are integrated and quality-checked before delivery
5. Professional communication protocols ensure smooth agent collaboration

---

### Technical Talk 🔧

The 5DXCC Framework implements a sophisticated multi-agent orchestration system through PowerShell automation hooks, JSON-based state management, and specialized agent definitions with domain-specific tool access.

## Architecture Overview

### Core Components
- **State Management System**: JSON-persisted state machine with transition detection
- **PowerShell Hook Pipeline**: 9 sequential automation hooks with intelligent behavior control
- **Agent Ecosystem**: 15 specialized agents with defined tools, protocols, and capabilities
- **Knowledge Management System**: Structured bug tracking, regex libraries, and historical knowledge retention
- **Workflow Automation**: Task detection and automatic pipeline execution

### State System

| State | Purpose | Tool Access | Available Agents | Automation |
|-------|---------|-------------|------------------|------------|
| `_chat` | Planning/Discussion | .md files, exploration | None (direct interaction) | Minimal |
| `_dev` | Development | Full access | dev-review, dev-dev, docs-elder | Supervisor-led workflows with historical consultation |
| `_exp` | Exploration | Read-only | exp-L0, exp-L1, exp-L2 | L0 Gateway + parallel execution |
| `_bug` | Debugging | Full access | bug-officer, think, specialists, docs-elder | 7-step systematic pipeline with docs-buglogger archival |
| `_data` | Data Analysis | Full access | data-flow, data-struct, data-api | Sequential optimization pipeline |
| `_docs` | Documentation | .md editing | docs-crawler, regex-expert, docs-buglogger | Research-focused workflows with pattern optimization |
| `_vanilla` | Clean Claude | No restrictions | None | Standard Claude Code |

### Debugging Mode Substates
When in `_bug` mode, the system progresses through specific substates for systematic investigation:

| Substate | Purpose | Key Activities | Primary Agents |
|----------|---------|----------------|----------------|
| `_understand` | Problem analysis | Initial investigation, symptom gathering | docs-elder, bug-officer |
| `_debuglog` | Systematic logging | Reproduction steps, detailed logging | bug-officer, specialists |
| `_fix` | Solution implementation | Code fixes, testing, validation | dev-dev, bug-officer |
| `_docs_buglog` | Knowledge archival | Post-fix documentation and categorization | docs-buglogger |
| `_revert` | Rollback capability | Undo changes if solution fails | dev-dev, bug-officer |

### Agent Specializations

#### Development Agents
- **dev-review**: Pre-implementation supervisor (architecture validation, standards compliance, risk assessment)
- **dev-dev**: Code implementation specialist (Write, Edit, MultiEdit, Bash, NotebookEdit)

#### Exploration Agents
- **exp-L0**: 60-second reconnaissance scout (rapid pattern recognition, delegation routing)
- **exp-L1**: Core architecture analyzer (entry points, business logic, main components)
- **exp-L2**: Dependency analyzer (utilities, helpers, supporting infrastructure)

#### Data Optimization Agents
- **data-flow**: Data transformation pipeline analyzer
- **data-struct**: Memory efficiency and data structure optimizer
- **data-api**: External data processing and validation specialist

#### Debugging & Support Agents
- **bug-officer**: Senior debugging coordinator with autonomous authority
- **think**: Critical analysis agent (assumption challenging, edge case identification)
- **regex-expert**: Cross-language regex specialist with security focus (core docs mode agent)
  - **Integration**: Primary pattern optimization agent in `_docs` mode for documentation workflows
  - **Knowledge Base**: Accesses comprehensive internal regex libraries for validation, extraction, and replacement patterns
  - **Cross-Language Support**: JavaScript (V8/ECMAScript), Python (re module), R (POSIX/PCRE)
  - **Security Focus**: ReDoS vulnerability detection, performance optimization, and safe pattern recommendations
- **docs-crawler**: Universal research agent (StackOverflow, GitHub, official docs)

#### Knowledge Management Agents
- **docs-elder**: Historical bug knowledge retrieval specialist (reactive consultation across dev/bug modes)
  - **Purpose**: Pure retrieval specialist for historical bug patterns and solutions
  - **Knowledge Base**: Searches across `.claude/knowledge/bugs/` with confidence-scored results
  - **Integration**: Consulted by dev-review and bug-officer before proceeding with complex issues
  - **Output**: Top 3 matching historical issues with pattern analysis and confidence scoring
- **docs-buglogger**: Bug knowledge archival specialist for post-debug documentation
  - **Purpose**: Analyzes completed debug sessions and creates structured knowledge entries
  - **Activation**: Manual invocation in `_docs_buglog` substate after successful debugging
  - **Process**: Extracts issue details, root causes, fixes, and automatically categorizes with 3-tag system
  - **Output**: Structured JSON entries in category-specific bug logs for future retrieval

#### Configuration Agents
- **statusline-setup**: Claude Code status line configuration specialist
- **output-style-setup**: Claude Code output style creation specialist

### Workflow Patterns

#### Development Workflow (Historical Consultation + Supervisor-Developer Pattern)
```
User Request → docs-elder (historical consultation) → dev-review (strategic planning) → dev-dev (implementation) → dev-review (QA) → User
```

#### Exploration Workflow (Layered Analysis)
```
User Request → exp-L0 (60s recon) → Multiple exp-L1/L2 (parallel) → Consolidated Report
```

#### Debugging Workflow (Historical Consultation + Systematic Investigation + Archival)
```
User Request → docs-elder (historical consultation) → _understand → bug-officer + parallel specialists → _debuglog → _fix → _docs_buglog (knowledge archival) → _revert (if needed)
```

#### Data Analysis Workflow (Parallel Optimization)
```
User Request → data-flow + data-struct + data-api (parallel) → Consolidated Recommendations
```

### PowerShell Hook Pipeline

#### Sequential UserPromptSubmit Chain
1. `help_command_hook.ps1` - Help system integration
2. `state_management_hook.ps1` - State transition management
3. `dev_pipeline_intelligent_hook.ps1` - Development task auto-detection
4. `data_pipeline_auto_hook.ps1` - Data analysis task automation
5. `exploration_pipeline_hook.ps1` - Exploration workflow automation
6. `debug_pipeline_hook.ps1` - Debug workflow coordination

#### State Management Infrastructure
- `statusline_4dcc.ps1` - Dynamic status line updates reflecting current mode
- `state_helper.ps1` - Core state management utility functions
- `state_validation_hook.ps1` - Enhanced tool validation and permission control

#### State Management Functions
- **Get-CurrentState**: Retrieve current operational state
- **Set-CurrentState**: Persist state transitions with timestamps
- **Test-BugOfficerAutonomy**: Validate autonomous agent authority
- **Test-ParallelExecutionCompatibility**: Ensure safe parallel agent execution

### Agent Communication Protocol
All agents follow professional courtesy standards:
- Start requests with "Could you please..."
- Use "Thank you for..." when acknowledging work
- Frame complex requests as "I'd appreciate your help with..."
- End with polite closings: "Much appreciated", "Thank you"

### Advanced Features

#### Autonomous Intelligence
- **bug-officer** can autonomously deploy specialist agents based on pattern detection
- **exp-L0** provides intelligent delegation routing based on complexity assessment
- **Parallel execution framework** with intelligent load balancing and conflict prevention

#### Knowledge Management Intelligence
- **Automatic bug logging**: Post-debug session documentation archival
- **Historical knowledge retrieval**: Pattern-based access to previous debugging solutions
- **Cross-session context retention**: Persistent debugging knowledge base
- **Regex pattern libraries**: Cross-language pattern optimization and security analysis

#### Quality Assurance Integration
- Built-in supervisor approval for architectural changes
- Standards compliance checking against CLAUDE.md requirements
- Professional communication protocols for agent collaboration
- Error handling with graceful degradation

#### Configuration Intelligence
- **Dynamic status line updates**: Real-time mode and state reflection
- **Environment-aware tool permissions**: Context-sensitive capability management
- **Automated configuration management**: Self-configuring development environment

#### R/Shiny Ecosystem Specialization
- **safe_execute()** pattern recognition and implementation
- **APP_CONFIG** usage patterns and configuration management
- Reactive programming pattern analysis
- Performance optimization recommendations

---

## Usage Instructions

### Getting Started
1. Navigate to your project directory containing the 5DXCC Framework
2. Type any state command to activate intelligent workflows:
   - `_dev` for development tasks
   - `_exp` for codebase exploration
   - `_bug` for debugging issues
   - `_data` for data analysis optimization
   - `_docs` for documentation tasks
   - `_chat` for planning and discussion

### State-Specific Usage

#### Development Mode (`_dev`)
**Available**: Full tool access, dev-review/dev-dev agents, supervisor-led workflows
**Best for**: Implementing new features, refactoring code, architectural changes

```
Example: "I need to add user authentication to my app _dev"
→ Triggers: dev-review (planning) → dev-dev (implementation) → quality assurance
```

#### Exploration Mode (`_exp`)
**Available**: Read-only access, exp-L0/L1/L2 agents, parallel analysis
**Best for**: Understanding codebases, analyzing architecture, dependency mapping

```
Example: "Help me understand this React codebase _exp"
→ Triggers: L0 reconnaissance → parallel L1/L2 analysis → consolidated report
```

#### Debugging Mode (`_bug`)
**Available**: Full access, bug-officer coordination, systematic 7-step pipeline
**Best for**: Investigating issues, performance problems, systematic debugging

```
Example: "My app is crashing on startup _bug"
→ Triggers: systematic investigation pipeline with autonomous specialist deployment
```

#### Data Analysis Mode (`_data`)
**Available**: Full access, data-flow/struct/api agents, optimization pipeline
**Best for**: Performance optimization, data structure analysis, API efficiency

```
Example: "Optimize my data processing pipeline _data"
→ Triggers: parallel data-flow + data-struct + data-api analysis
```

### Advanced Usage

#### Manual Agent Invocation
You can manually invoke specific agents using the Task tool:
```
Task dev-review "Could you please review this authentication implementation for security best practices? Much appreciated."
```

#### State Transitions
States automatically persist across sessions. To change states:
```
_vanilla  # Return to standard Claude Code
_chat     # Switch to planning mode
```

#### Parallel Agent Coordination
The framework automatically handles parallel agent execution for complex tasks. Agents coordinate using professional communication protocols and avoid conflicts through intelligent workload distribution.

---

## Installation & Integration

### ⚠️ **IMPORTANT DISCLAIMER**

**Before adding this framework to an existing project:**

1. **Backup your existing files**: 
   - `CLAUDE.md` - Contains your project-specific instructions
   - `.claude/settings.local.json` - Contains your current Claude Code configuration

2. **Do NOT overwrite existing files**:
   - The `CLAUDE.md` in this repository contains 5DXCC-specific instructions
   - The `settings.local.json` contains hook configurations that may conflict with your setup

3. **Integration approach**:
   - **Option A**: Merge the 5DXCC instructions into your existing `CLAUDE.md`
   - **Option B**: Rename your existing files and use the 5DXCC versions
   - **Option C**: Create a separate development environment for 5DXCC testing

### Integration Steps
1. Copy the `.claude/` directory to your project (excluding files you want to preserve)
2. Merge or replace `CLAUDE.md` with your project-specific requirements
3. Configure `settings.local.json` to include the PowerShell hook chain
4. Test the framework with simple state transitions (`_chat`, `_exp`)
5. Gradually adopt more complex workflows (`_dev`, `_bug`, `_data`)

### Prerequisites
- Claude Code installed and configured
- PowerShell execution environment
- JSON file read/write permissions in the `.claude/` directory

### Verification
Test the installation by typing `_chat` and verifying you receive a state transition message. Then try `_exp` with a simple exploration request to confirm agent coordination is working.

---

## Framework Benefits

### For Individual Developers
- **Intelligent task detection**: Automatic workflow activation based on request complexity
- **Expert guidance**: Specialized agents provide domain-specific recommendations
- **Quality assurance**: Built-in supervisor patterns prevent common mistakes
- **Reduced cognitive load**: Framework handles coordination and planning

### For Development Teams
- **Consistent workflows**: Standardized approaches to common development tasks
- **Knowledge sharing**: Agent expertise captures best practices and standards
- **Quality gates**: Automatic validation and review processes
- **Documentation**: Professional communication creates audit trails

### For Complex Projects
- **Systematic approaches**: Multi-phase workflows for complex tasks
- **Parallel processing**: Multiple agents work simultaneously on different aspects
- **Risk mitigation**: Supervisor approval for architectural changes
- **Scalable intelligence**: Framework adapts to project complexity
- **Historical learning**: Automated capture and retrieval of debugging solutions
- **Pattern recognition**: Cross-project knowledge application
- **Documentation automation**: Self-documenting debugging processes

---

## Support & Documentation

- **Framework Documentation**: `.claude/5DXCC-SYSTEM-DOCUMENTATION.md`
- **Agent Definitions**: `.claude/agents/*.md` (15 specialized agent configurations)
- **Hook Implementation**: `.claude/hooks/` (PowerShell automation scripts)
- **State Management**: `.claude/state.json` (Persistent state tracking)
- **Knowledge Base**:
  - **Bug Knowledge**: `.claude/knowledge/bugs/` (Historical debugging solutions)
  - **Regex Libraries**: `.claude/knowledge/regex/` (Cross-language pattern optimization)

### Troubleshooting

#### Common Issues
1. **PowerShell Execution Policy**: Requires `-ExecutionPolicy Bypass` for hook execution
2. **State File Corruption**: System defaults to "dev" mode with automatic recovery
3. **Hook Failures**: Individual hooks fail gracefully without system impact
4. **Agent Invocation Issues**: Check tool permissions and agent definitions
5. **Knowledge Management Issues**:
   - Bug log corruption recovery through docs-elder agent
   - Historical knowledge retrieval failures
   - Cross-session state persistence problems

#### Debug Information
- State transitions logged with timestamps in `state.json`
- Hook execution traced through PowerShell error outputs
- Agent execution logs available through Task tool responses
- Knowledge base access logs in `.claude/knowledge/` subdirectories

For issues, questions, or contributions, please refer to the comprehensive system documentation included with the framework.

---

*The 5DXCC Framework represents a new paradigm in AI-assisted development, transforming individual AI interactions into coordinated multi-agent workflows with built-in quality assurance and professional standards.*