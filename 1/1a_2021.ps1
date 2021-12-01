<#
Find count where the next array element is greater than the previous one
#>

$strarray = Get-Content ina.txt
$answer = 0
$prev = [int]$strarray[0]

foreach ($line in $strarray) {
    $curr = [int]$line
    if ($curr -gt $prev) {
        $answer = $answer + 1
    }

    $prev = $curr
}

Write-Host $answer
