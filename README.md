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
- **Specialized expertise**: 13 expert agents covering development, debugging, data analysis, exploration, and research

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
- **PowerShell Hook Pipeline**: 11 sequential automation hooks with intelligent behavior control
- **Agent Ecosystem**: 13 specialized agents with defined tools, protocols, and capabilities
- **Workflow Automation**: Task detection and automatic pipeline execution

### State System

| State | Purpose | Tool Access | Available Agents | Automation |
|-------|---------|-------------|------------------|------------|
| `_chat` | Planning/Discussion | .md files, exploration | None (direct interaction) | Minimal |
| `_dev` | Development | Full access | dev-review, dev-dev | Supervisor-led workflows |
| `_exp` | Exploration | Read-only | exp-L0, exp-L1, exp-L2 | L0 Gateway + parallel execution |
| `_bug` | Debugging | Full access | bug-officer, think, specialists | 7-step systematic pipeline |
| `_data` | Data Analysis | Full access | data-flow, data-struct, data-api | Sequential optimization pipeline |
| `_docs` | Documentation | .md editing | docs-crawler | Research-focused workflows |
| `_vanilla` | Clean Claude | No restrictions | None | Standard Claude Code |

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
- **regex-expert**: Cross-language regex specialist with security focus
- **docs-crawler**: Universal research agent (StackOverflow, GitHub, official docs)

### Workflow Patterns

#### Development Workflow (Supervisor-Developer Pattern)
```
User Request → dev-review (strategic planning) → dev-dev (implementation) → dev-review (QA) → User
```

#### Exploration Workflow (Layered Analysis)
```
User Request → exp-L0 (60s recon) → Multiple exp-L1/L2 (parallel) → Consolidated Report
```

#### Debugging Workflow (Systematic Investigation)
```
_understand → bug-officer + parallel specialists → _debuglog → _fix → _revert (if needed)
```

#### Data Analysis Workflow (Parallel Optimization)
```
User Request → data-flow + data-struct + data-api (parallel) → Consolidated Recommendations
```

### PowerShell Hook Pipeline

#### Sequential UserPromptSubmit Chain
1. `help_command_hook.ps1` - Help system integration
2. `no_you_are_right_hook.ps1` - Behavior control (prevents reflexive agreement)
3. `state_management_hook.ps1` - State transition management
4. `dev_pipeline_intelligent_hook.ps1` - Development task auto-detection
5. `data_pipeline_auto_hook.ps1` - Data analysis task automation
6. `exploration_pipeline_hook.ps1` - Exploration workflow automation
7. `debug_pipeline_hook.ps1` - Debug workflow coordination

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

#### Quality Assurance Integration
- Built-in supervisor approval for architectural changes
- Standards compliance checking against CLAUDE.md requirements
- Professional communication protocols for agent collaboration
- Error handling with graceful degradation

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

---

## Support & Documentation

- **Framework Documentation**: `.claude/5DXCC-SYSTEM-DOCUMENTATION.md`
- **Agent Definitions**: `.claude/agents/*.md`
- **Hook Implementation**: `.claude/hooks/`
- **State Management**: `.claude/state.json`

For issues, questions, or contributions, please refer to the comprehensive system documentation included with the framework.

---

*The 5DXCC Framework represents a new paradigm in AI-assisted development, transforming individual AI interactions into coordinated multi-agent workflows with built-in quality assurance and professional standards.*