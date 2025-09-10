# State Management Helper Functions
# Shared functions for reading/writing JSON state

# Read current state from JSON file
function Get-CurrentState {
    param(
        [string]$StateFile = "C:\Users\sasha\OneDrive\Documents\Data Simple 3\data_simple\.claude\state.json"
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
        [string]$StateFile = "C:\Users\sasha\OneDrive\Documents\Data Simple 3\data_simple\.claude\state.json",
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

# Validate bug-officer autonomous authority for think summoning
function Test-BugOfficerAutonomy {
    param(
        [string]$CurrentState = $null,
        [string]$SubagentType = $null
    )
    
    if (-not $CurrentState) {
        $CurrentState = Get-CurrentState
    }
    
    # Bug-officer has enhanced autonomous authority in bug modes for think summoning
    if ($CurrentState -match "^bug") {
        if ($SubagentType -eq "bug-officer") {
            return @{
                HasAutonomy = $true
                CanSummonThink = $true
                CanDeployParallel = $true
                CanMakeTacticalDecisions = $true
                AuthorityLevel = "FULL_AUTONOMOUS"
                ValidationPassed = $true
            }
        }
        
        # Think agent can be summoned by bug-officer without user confirmation
        if ($SubagentType -eq "think") {
            return @{
                HasAutonomy = $true
                RequiresBugOfficerApproval = $false
                CanBeDeployedAutonomously = $true
                AuthorityLevel = "AUTONOMOUS_DEPLOYMENT"
                ValidationPassed = $true
            }
        }
        
        # Other investigation agents have standard authority in bug mode
        $bugInvestigationAgents = @("exp-L1", "docs-crawler", "data-flow", "data-struct", "data-api", "regex-expert")
        if ($SubagentType -in $bugInvestigationAgents) {
            return @{
                HasAutonomy = $false
                CanSummonThink = $false
                CanDeployParallel = $false
                CanMakeTacticalDecisions = $false
                AuthorityLevel = "STANDARD_INVESTIGATION"
                ValidationPassed = $true  # Allowed but not autonomous
            }
        }
    }
    
    # Think agent in exploration mode has limited autonomy
    if ($CurrentState -eq "exp" -and $SubagentType -eq "think") {
        return @{
            HasAutonomy = $false
            RequiresBugOfficerApproval = $true
            CanBeDeployedAutonomously = $false
            AuthorityLevel = "LIMITED_DEPLOYMENT"
            ValidationPassed = $true
        }
    }
    
    # General-purpose and master agents are standard across all states
    if ($SubagentType -in @("general-purpose", "master")) {
        return @{
            HasAutonomy = $false
            CanSummonThink = $false
            CanDeployParallel = $false
            CanMakeTacticalDecisions = $false
            AuthorityLevel = "STANDARD"
            ValidationPassed = $true
        }
    }
    
    return @{
        HasAutonomy = $false
        CanSummonThink = $false
        CanDeployParallel = $false
        CanMakeTacticalDecisions = $false
        AuthorityLevel = "STANDARD"
        ValidationPassed = $false
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
        $maxAgents = 6  # bug-officer + up to 3 exp-L1 + docs-crawler + think + master
        $compatibleAgents = @("bug-officer", "exp-L1", "docs-crawler", "data-flow", "data-struct", "data-api", "think", "regex-expert", "general-purpose", "master")
    }
    elseif ($CurrentState -eq "exp") {
        $supportsParallel = $true
        $maxAgents = 5  # exp-L0 + up to 3 exp-L1/L2 + think + master
        $compatibleAgents = @("exp-L0", "exp-L1", "exp-L2", "think", "docs-crawler", "general-purpose", "master")
    }
    elseif ($CurrentState -eq "data") {
        $supportsParallel = $true
        $maxAgents = 5  # data specialists + docs-crawler + master
        $compatibleAgents = @("data-flow", "data-struct", "data-api", "docs-crawler", "general-purpose", "master")
    }
    elseif ($CurrentState -eq "dev") {
        $supportsParallel = $true
        $maxAgents = 4  # dev-review + up to 3 dev-dev + master
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
    $thinkIncluded = $false
    
    foreach ($agent in $AgentTypes) {
        if ($agent -in $compatibleAgents) {
            $validatedAgents += $agent
            if ($agent -eq "think") {
                $thinkIncluded = $true
            }
        }
    }
    
    return @{
        SupportsParallelExecution = $supportsParallel
        MaxAgents = $maxAgents
        RequestedAgents = $AgentTypes.Count
        ValidatedAgents = $validatedAgents
        ThinkAgentIncluded = $thinkIncluded
        CanExecuteInParallel = ($validatedAgents.Count -le $maxAgents -and $supportsParallel)
        CompatibilityPassed = ($validatedAgents.Count -eq $AgentTypes.Count -and $supportsParallel)
    }
}