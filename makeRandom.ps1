#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# this script was translated from my makeRandom.sh by chatgpt, bugs may be present
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
param(
    [string]$n = "randomSpawns.cfg",
    [switch]$c,
    [switch]$t,
    [int]$a = 50,
    [string]$r,
    [string]$l,
    [switch]$h
)

if ($h) {
    Write-Output "Script which generates random spawns for cs2, compatible with xxxSpawns.cfg files"
    Write-Output ""
    Write-Output "Arguments:"
    Write-Output "-n <fileName>    Set destination file name"
    Write-Output "-t               Generate T spawns"
    Write-Output "-c               Generate CT spawns"
    Write-Output "-a <amount>      Amount of random spawns to generate (default: 50)"
    Write-Output "-r <letter>      Range of letters, e.g. 'e' means a-e"
    Write-Output "-l <letters>     Exact letters to use, e.g. 'abdef'"
    Write-Output ""
    Write-Output "Example:"
    Write-Output "./makeRandom.ps1 -n trainrandom.cfg -t -a 20 -r f"
    exit
}

# Determine side
$side = if ($c) { "ct" } else { "t" }

# Build letter array
if ($r) {
    $letters = @()
    foreach ($ch in [char[]](97..[int][char]$r)) {
        $letters += $ch
    }
} elseif ($l) {
    $letters = $l.ToCharArray()
} else {
    $letters = @('a','b','c','d','e')
}

# Confirm file overwrite
if (Test-Path $n) {
    $answer = Read-Host "File '$n' already exists. Overwrite? (y/n)"
    if ($answer -notin @("y", "Y")) {
        Write-Output "Exiting script."
        exit
    }
    Write-Output "Overwriting file '$n'"
}

# Start writing the alias chain
"alias randomSpawn `"randomSpawn0`"" | Out-File -Encoding ASCII -FilePath $n

for ($i = 0; $i -lt $a; $i++) {
    $next = $i + 1
    $randLetter = Get-Random -InputObject $letters
    $line = "alias randomSpawn$i `"alias randomSpawn `"randomSpawn$next loc$side$randLetter`"`""
    $line | Out-File -Append -Encoding ASCII -FilePath $n
}

# Final alias
$lastLetter = Get-Random -InputObject $letters
$finalLine = "alias randomSpawn$a `"alias randomSpawn `"randomSpawn$($a+1) loc$side$lastLetter`"`""
$finalLine | Out-File -Append -Encoding ASCII -FilePath $n