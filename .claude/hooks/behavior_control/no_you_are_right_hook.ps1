# Claude Code hook to prevent "you are right" responses
# PowerShell version for Windows

param()

$ErrorActionPreference = "Stop"

try {
    # Read stdin
    $stdin = [Console]::In.ReadToEnd()
    $inputData = $stdin | ConvertFrom-Json
    $transcriptPath = $inputData.transcript_path
    
    # Load state helper and check for vanilla mode
    . "$PSScriptRoot\..\state_management\state_helper.ps1"
    $currentState = Get-CurrentState
    
    # Early exit for vanilla mode - disable critical analysis enforcement
    if ($currentState -eq "vanilla") {
        exit 0
    }

    # Check if transcript file exists
    if (-not (Test-Path $transcriptPath)) {
        exit 0
    }

    # Read and parse transcript
    $transcriptContent = Get-Content $transcriptPath -Raw | ConvertFrom-Json
    
    # Get last 5 assistant messages
    $assistantMessages = $transcriptContent | Where-Object { $_.role -eq "assistant" } | Select-Object -Last 5
    
    $needsReminder = $false
    
    foreach ($item in $assistantMessages) {
        if ($item.type -eq "assistant" -and $item.message.content -and $item.message.content[0].type -eq "text") {
            $text = $item.message.content[0].text
            $first80 = $text.Substring(0, [Math]::Min(80, $text.Length))
            
            # Check for triggering phrases
            if ($first80 -match "(?i)you.*(right|correct)" -or 
                $first80 -match "(?i)absolutely" -or
                $first80 -match "사용자가.*맞다" -or
                $first80 -match "맞습니다") {
                $needsReminder = $true
                break
            }
        }
    }
    
    if (-not $needsReminder) {
        exit 0
    }
    
    # Output system reminder
    Write-Output @'
<system-reminder>
You MUST NEVER use the phrase 'you are right' or similar.
Avoid reflexive agreement. Instead, provide substantive technical analysis.
You must always look for flaws, bugs, loopholes, counter-examples,
invalid assumptions in what the user writes. If you find none,
and find that the user is correct, you must state that dispassionately
and with a concrete specific reason for why you agree, before
continuing with your work.
<example>
user: It's failing on empty inputs, so we should add a null-check.
assistant: That approach seems to avoid the immediate issue.
However it's not idiomatic, and hasn't considered the edge case
of an empty string. A more general approach would be to check
for falsy values.
</example>
<example>
user: I'm concerned that we haven't handled connection failure.
assistant: [thinks hard] I do indeed spot a connection failure
edge case: if the connection attempt on line 42 fails, then
the catch handler on line 49 won't catch it.
[ultrathinks] The most elegant and rigorous solution would be
to move failure handling up to the caller.
</example>
</system-reminder>
'@

    exit 0
}
catch {
    # If anything fails, just exit without blocking
    exit 0
}