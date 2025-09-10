# Data Pipeline Auto-Invocation Hook
# Automatically invokes data analysis pipeline for data tasks in data mode

param()

$ErrorActionPreference = "Stop"

# Load state helper functions
. "$PSScriptRoot\state_helper.ps1"

try {
    # Read stdin to get user prompt
    $stdin = [Console]::In.ReadToEnd()
    
    # Skip processing if no input
    if ([string]::IsNullOrWhiteSpace($stdin)) {
        exit 0
    }
    
    $inputData = $stdin | ConvertFrom-Json
    
    # Get current state
    $currentState = Get-CurrentState
    
    # Only proceed if in data mode
    if ($currentState -ne "data") {
        exit 0
    }
    
    # Get user prompt
    $userPrompt = $inputData.prompt
    
    # Data analysis task detection - comprehensive pattern matching
    $dataAnalysisPatterns = @(
        "(?i)(analyze|analysis|examine|inspect|review|evaluate|assess|investigate|study|explore)",
        "(?i)(data\s+(flow|structure|pipeline|quality|validation|transformation|processing))",
        "(?i)(performance|efficiency|optimization|bottleneck|memory\s+usage|speed|latency)",
        "(?i)(api\s+(call|request|response|handling|validation|optimization|rate\s+limiting))",
        "(?i)(trace|track|follow|monitor|debug|profile|benchmark)",
        "(?i)(identify|find|detect|locate|discover)\s+(issue|problem|inefficienc|bottleneck|error)",
        "(?i)(improve|optimize|enhance|streamline|refactor)\s+(data|performance|api)",
        "(?i)(validate|verify|check|test)\s+(data|structure|api|pipeline)",
        "(?i)(memory|storage|cache|database|file\s+system)\s+(usage|efficiency|optimization)",
        "(?i)(transform|convert|process|parse|clean|format)\s+data"
    )
    
    # Check if prompt matches any data analysis patterns
    $isDataTask = $false
    foreach ($pattern in $dataAnalysisPatterns) {
        if ($userPrompt -match $pattern) {
            $isDataTask = $true
            break
        }
    }
    
    if ($isDataTask) {
        # Inject automatic data pipeline orchestration instruction
        Write-Output @"
<system-reminder>
**DATA MODE PIPELINE AUTO-ACTIVATION**

Data analysis task detected: "$userPrompt"

AUTOMATICALLY execute this workflow:
1. Use Task data-flow "Analyze data flow and identify transformation inefficiencies for: $userPrompt" - Trace data transformations
2. Use Task data-struct "Evaluate data structures and memory efficiency for: $userPrompt" - Assess structural optimization
3. Use Task data-api "Optimize API data handling and validation for: $userPrompt" - Enhance API performance
4. Present consolidated analysis results to user

Do NOT ask user for confirmation between steps. Execute data-flow → data-struct → data-api → results automatically.
This pipeline ONLY activates for data analysis tasks requiring comprehensive structural evaluation.
</system-reminder>
"@
    }
    
    exit 0
}
catch {
    # If anything fails, just exit without blocking
    exit 0
}