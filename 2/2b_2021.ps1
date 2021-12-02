<#
Find count where the next array element is greater than the previous one
#>

$strarray = Get-Content ina.txt
$answer = 0
$xpos = 0
$ypos = 0
$aim = 0

foreach ($line in $strarray) {
    $move = $line -split " "
    $dir = $move[0]
    $distance = $move[1]
    if ($dir -eq "forward") {
        $xpos += $distance
        $ypos += $distance * $aim
    } elseif ($dir -eq "down") {
        $aim += $distance
    } elseif ($dir -eq "up") {
        $aim -= $distance
    }
}

Write-Host $xpos $ypos
Write-Host $($xpos*$ypos)
