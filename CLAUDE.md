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