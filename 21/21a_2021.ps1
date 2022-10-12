<#

#>

#offset start by 1 as doing pos 0-9 instead of 1-10
$p1pos = 7 - 1
$p2pos = 5 - 1

$p1score = 0
$p2score = 0

$dieStart = 1

$rollCount = 0
$currPlayerOne = $true
$answer = 0

while (($p1score -lt 1000) -and ($p2score -lt 1000)) {
    
    $secondRoll = $dieStart + 1
    $thirdRoll = $dieStart + 2
    if ($secondRoll -gt 100) { $secondRoll -= 100 }
    if ($thirdRoll -gt 100) { $thirdRoll -= 100 }

    $rollSum = $dieStart + $secondRoll + $thirdRoll

    if ($currPlayerOne) {
        $p1pos = ($p1pos + $rollSum) % 10
        $p1Score += $p1pos + 1
    } else {
        $p2pos = ($p2pos + $rollSum) % 10
        $p2Score += $p2pos + 1
    }

    #End of Loop increments
    $rollCount += 3
    $dieStart += 3
    if ($dieStart -gt 100) { $dieStart -= 100 }

    $currPlayerOne = !$currPlayerOne
}

$losingScore = 0
if ($p1score -gt $p2score) {
    $losingScore = $p2score
} else {
    $losingScore = $p1score
}

$answer = $rollCount * $losingScore
Write-Host $answer
