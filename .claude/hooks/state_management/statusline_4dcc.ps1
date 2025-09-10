# 5DXCC Framework Status Line - Enhanced with Model and Session Info
param()

$ErrorActionPreference = "Continue"

try {
    # Read stdin (same as working debug version)
    $stdin = [Console]::In.ReadToEnd()
    
    # Read 5DXCC state with absolute path
    $stateFile = "C:\Users\sasha\OneDrive\Documents\Data Simple 3\data_simple\.claude\state.json"
    $currentState = "dev"
    $substate = $null
    $sessionInfo = ""
    $transitionCount = 0
    
    if (Test-Path $stateFile) {
        $content = Get-Content $stateFile -Raw
        $json = $content | ConvertFrom-Json
        $currentState = $json.current_state
        $substate = $json.substate
        
        # Skip session and transition info to save space for agents display
    }
    
    # Get git branch
    $gitBranch = "main"
    try {
        $gitBranch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($LASTEXITCODE -ne 0) {
            $gitBranch = "main"
        }
    } catch {
        $gitBranch = "main"
    }
    
    # Simple dimension mapping with substate support
    switch ($currentState) {
        "chat" { $mode = "Discovery" }
        "dev" { $mode = "Development" }
        "bug" { 
            if ($substate) {
                $mode = "Debugging / $substate"
            } else {
                $mode = "Debugging"
            }
        }
        "docs" { $mode = "Documentation" }
        "exp" { $mode = "Exploration" }
        "data" { $mode = "Data Analysis" }
        "vanilla" { $mode = "Vanilla" }
        default { $mode = "Development" }
    }
    
    # Model information (static since Claude Desktop doesn't expose runtime model info)
    $modelInfo = "Sonnet-4"
    
    # Remove context indicator to save space for agents
    
    # Get available subagents
    $agentsPath = "C:\Users\sasha\OneDrive\Documents\Data Simple 3\data_simple\.claude\agents"
    $availableAgents = @()
    $stateAgents = @()
    
    if (Test-Path $agentsPath) {
        $agentFiles = Get-ChildItem -Path $agentsPath -Filter "*.md" -Name
        
        # Show all available agents instead of filtering by state
        # This ensures users can see all available specialized agents
        $availableAgents = $agentFiles | ForEach-Object { ($_ -replace '\.md$', '') } | Sort-Object
    }
    
    # Format agents display
    $agentsDisplay = if ($availableAgents.Count -gt 0) { 
        "Agents: " + ($availableAgents -join ", ")
    } else { 
        "Agents: none"
    }
    
    # Available commands for quick reference
    $commands = "_help _chat _dev _bug _docs _exp _data _vanilla"
    
    # Debug-specific substates
    $debugCommands = ""
    if ($currentState -eq "bug") {
        $debugCommands = " | Debug: _understand _debuglog _fix _revert"
    }
    
    # ANSI color codes for enhanced visual appeal
    $esc = [char]27
    $reset = "$esc[0m"
    $cyan = "$esc[36m"           # Cyan for 5DXCC
    $green = "$esc[32m"          # Green for mode
    $yellow = "$esc[33m"         # Yellow for git branch
    $blue = "$esc[34m"           # Blue for model info
    $magenta = "$esc[35m"        # Magenta for agents
    $white = "$esc[37m"          # White for commands
    
    # Enhanced output with model info and available agents (colorized)
    Write-Output "${cyan}5DXCC:${reset} ${green}${mode}${reset} ${white}|${reset} ${yellow}${gitBranch}${reset} ${white}|${reset} ${blue}${modelInfo}${reset} ${white}|${reset} ${magenta}${agentsDisplay}${reset} ${white}|${reset} ${white}Commands: ${commands}${debugCommands}${reset}"
    
} catch {
    # Fallback without colors in case of errors
    Write-Output "5DXCC: Development | main | Sonnet-4 | Agents: bug-officer, data-api, data-flow, data-struct, dev-dev, dev-review, docs-crawler, exp-L0, exp-L1, exp-L2, think | Commands: _help _chat _dev _bug _docs _exp _data _vanilla"
}