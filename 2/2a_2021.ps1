<#
Find count where the next array element is greater than the previous one
#>

$strarray = Get-Content ina.txt
$answer = 0
$xpos = 0
$ypos = 0

foreach ($line in $strarray) {
    $move = $line -split " "
    $dir = $move[0]
    $distance = $move[1]
    if ($dir -eq "forward") {
        $xpos += $distance
    } elseif ($dir -eq "down") {
        $ypos += $distance
    } elseif ($dir -eq "up") {
        $ypos -= $distance
    }
}

Write-Host $xpos $ypos
Write-Host $($xpos*$ypos)
