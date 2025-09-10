# 5DXCC System Improvements Requirements

**Document Version**: 1.0  
**Date**: 2025-09-08  
**Status**: Requirements Definition

## Overview

This document outlines the key improvements needed for the Five-Dimensional Extended Claude Code (5DXCC) system based on identified pain points and optimization opportunities.

## 1. Agent Performance Logging & Visibility

### Current Issues
- Limited visibility into agent inner workings, especially slow agents (exp-L1, exp-L2, docs-crawler)
- Unknown if parallel agents perform redundant work
- Need insights into dev-review agent reasoning and recommendations

### Requirements

#### Session-Based Logging Structure
```
.claude/logs/
├── session_20250908_123107/
│   ├── agent_exp-L1_001.log
│   ├── agent_exp-L2_001.log  
│   ├── agent_docs-crawler_001.log
│   └── session_summary.log
└── session_20250908_140215/
    └── ...
```

#### Log Content Requirements
**For each agent execution**:
- **Timestamp**: When agent started/finished
- **Actions Taken**: Tools used (Read, Grep, Glob, WebSearch, etc.)
- **Brief Descriptions**: 1 sentence per action explaining what was done
- **Final Report**: Complete agent response as sent back to master agent
- **No redundant data**: Agents append without reading existing content

#### Target Agents for Logging
- **Primary Focus**: exp-L1, exp-L2, docs-crawler, dev-review
- **Secondary**: All other agents for comprehensive coverage
- **Performance Tracking**: Identify bottlenecks and redundancies

## 2. Debug Mode Enhancement

### Current Issues
- Debug mode lacks access to dev-review and dev-dev agents
- 7-step debugging pipeline too complex
- Need implementation capabilities during debugging

### Requirements

#### Simplified Debug Mode Access
- **All Agents Available**: Debug mode gets access to every agent type
- **No Restrictions**: Remove current agent limitations in debug mode
- **Git Safety Net**: Rely on git rollback for safety rather than access restrictions
- **Simplified Pipeline**: Streamline debugging process (details TBD)

#### Implementation Strategy
- Phase-based access no longer needed
- Direct access to dev agents for fix implementation
- Maintain systematic approach but with full toolkit

## 3. Exploration Mode Pipeline Enhancement

### Current Issues
- No structured exploration workflow
- Shallow agent system prompts without delegation guidelines
- Master agent lacks clear strategy for leveraging exp agents
- No rules for parallel agent utilization

### Requirements

#### New Agent: exp-L0 (Reconnaissance Agent)
**Purpose**: Ultra high-level reconnaissance to inform intelligent delegation strategy

**Tools**: Read, Glob, Grep (with scope limitations)
- **File Limits**: Maximum 10 files per directory scan
- **Depth Limits**: Top-level and one subdirectory level only
- **Pattern Focus**: Configuration files, main entry points, README files
- **Time Constraint**: Quick scan approach, no deep analysis

**Core Functions**:
1. **Project Structure Mapping**: Directory layout, file organization patterns
2. **Technology Stack Detection**: Identify programming languages, frameworks, package/dependency files
3. **Entry Point Identification**: Find main application files, configuration files, build scripts
4. **Complexity Assessment**: File counts, directory depth, apparent system size
5. **Dependency Indicators**: Import/include patterns, module loading, library usage (surface level only)

**Delegation Intelligence Output**:
```
## L0 RECONNAISSANCE REPORT

### Project Overview
- **Structure**: [Single application / Multi-module / Library/Package / Mixed structure]
- **Technology**: [Primary language(s) and frameworks detected]  
- **Complexity**: [Simple / Medium / Complex] based on file counts and structure
- **Entry Points**: [Main files, configuration files, build scripts identified]

### Recommended Delegation Strategy
- **L1 Agents Needed**: [1-3] for [specific reasons]
- **L2 Analysis Required**: [Yes/No] because [reasoning]
- **Parallel Coordination**: [Task division strategy if multiple agents]
- **Scope Boundaries**: [Directories to focus on / Dependencies outside scope]
- **User Confirmation Needed**: [Cross-directory dependencies found: Y/N]

### Task Assignments (if multiple agents recommended)
1. **L1-Agent-1**: Focus on [specific area/files]
2. **L1-Agent-2**: Analyze [different area/files] 
3. **L2-Agent-1**: Deep dive into [utilities/dependencies] after L1 completion
```

**Value Proposition**:
- **Prevents Over-delegation**: Avoids launching 3 agents for simple single-file tasks
- **Improves Coordination**: Clear task division when multiple agents are needed  
- **Scope Management**: Identifies boundary issues before deep analysis begins
- **Efficiency**: Quick assessment prevents redundant work patterns
- **User Communication**: Early identification of scope expansion needs

#### Master Agent Intelligence Layer
The master agent should:
1. **Brief Direct Assessment**: Quick overview using exp-L0 agent
2. **Intelligent Delegation**: Use L0 output to plan L1/L2 strategy
3. **No Direct Exploration**: Master never does deep exploration directly
4. **User Scope Respect**: Stay within requested directories unless confirmed

#### Agent Delegation Decision Matrix
```
Request Scope → Agent Strategy
├── Single file/function → 1x L1 agent
├── Directory/module → exp-L0 → 1x L1 + 1x L2 (sequential)
├── Multiple unrelated files → exp-L0 → up to 3x L1 parallel
├── Complex system analysis → exp-L0 → 2-3x L1 + 2-3x L2 (coordinated)
└── Cross-directory dependencies → exp-L0 → confirm scope expansion
```

#### Parallel Agent Coordination Rules
- **Maximum Parallel**: 3x L1 agents, 3x L2 agents
- **Task Division**: Clear, non-overlapping assignments
- **Organic Scaling**: Based on request complexity, not fixed patterns
- **Directory Boundaries**: Strict adherence unless user expands scope

#### PowerShell Hook Implementation
- **New Hook**: `exploration_pipeline_hook.ps1`
- **Trigger**: Exploration tasks in exp mode
- **Function**: Enforce delegation rules and coordination
- **Integration**: Similar pattern to dev/data pipeline hooks

## 4. Implementation Strategy

### Phase 1: Logging Infrastructure
1. Create session-based logging system
2. Implement agent execution tracking
3. Test with high-usage agents (exp-L1, exp-L2, docs-crawler)

### Phase 2: Debug Mode Enhancement  
1. Remove agent restrictions in debug mode
2. Update state validation hook
3. Simplify debugging pipeline (specific changes TBD)

### Phase 3: Exploration Pipeline
1. Create exp-L0 agent definition
2. Implement exploration_pipeline_hook.ps1
3. Update master agent delegation logic
4. Test parallel coordination patterns

### Phase 4: Integration & Testing
1. Test all improvements together
2. Validate performance optimizations
3. Refine based on actual usage patterns

## 5. Success Criteria

### Logging Success
- Clear visibility into agent reasoning and actions
- Identification of performance bottlenecks
- Detection of redundant work patterns

### Debug Enhancement Success
- Faster bug resolution with full agent access
- Simplified debugging workflow
- Maintained safety through git version control

### Exploration Pipeline Success  
- Consistent, intelligent exploration strategies
- Effective parallel agent coordination
- Improved exploration thoroughness and efficiency
- Clear scope boundaries with user confirmation for expansion

## 6. Next Steps

1. **Document Review**: Validate requirements accuracy
2. **Mode Transition**: Switch to `_dev` mode for implementation
3. **Priority Selection**: Choose which phase to implement first
4. **Implementation Planning**: Detailed technical specification for chosen phase

## Notes

- All improvements maintain backward compatibility with existing workflows
- Implementation should leverage existing PowerShell hook infrastructure
- Changes should not disrupt current agent specialization and tool restrictions in other modes
- Git-based safety model provides flexibility while maintaining system stability