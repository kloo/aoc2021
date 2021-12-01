<#
Find count where the sum of 3 consecutive elements at pos x is less than the sum of the 3 consecutive elements at pos x+1
#>

$strarray = Get-Content ina.txt
$answer = 0
$prev = 9999999999

for ($i = 0; $i -lt ($strarray.Count - 2);$i++) {
    $curr = ([int]$strarray[$i]) + ([int]$strarray[$i+1]) + ([int]$strarray[$i+2])

    if ($curr -gt $prev) {
        $answer = $answer + 1
    }

    $prev = $curr
}

Write-Host $answer
