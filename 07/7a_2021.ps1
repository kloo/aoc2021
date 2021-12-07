<#
Find optimal fuel efficiency
#>

$strarray = Get-Content inb.txt
$crabArray = [int64[]] $strarray.Split(",") | Sort
$dayCount = 80
$closeCrab = $crabArray[0]
$farCrab = $crabArray[$crabArray.Count - 1]

$fuelArray = New-Object int64[] $($farCrab + 1)

for ($j = 0; $j -lt $fuelArray.Count;$j++) {
    $fuelArray[$j] = 0
}

for ($i = 0; $i -lt $fuelArray.Count;$i++) {
    for ($j = 0; $j -lt $crabArray.Count;$j++) {
        $fuelArray[$i] += [Math]::Abs($crabArray[$j] - $i)
    }
}


Write-Host $($fuelArray | Sort)[0]