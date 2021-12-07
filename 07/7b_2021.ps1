<#
Find optimal fuel efficiency with triangle number costs
#>

$strarray = Get-Content inb.txt
$crabArray = [int64[]] $strarray.Split(",") | Sort
$dayCount = 80
$closeCrab = $crabArray[0]
$farCrab = $crabArray[$crabArray.Count - 1]

$fuelArray = New-Object int64[] $($farCrab + 1)
$triangleArray = New-Object int64[] $fuelArray.Count

$triangleArray[0] = 0
#Build Triangle Number Array
for ($i = 1; $i -lt $fuelArray.Count;$i++) {
    $triangleArray[$i] = $triangleArray[$i-1] + $i
}

for ($j = 0; $j -lt $fuelArray.Count;$j++) {
    $fuelArray[$j] = 0
}

for ($i = $closeCrab; $i -lt $fuelArray.Count;$i++) {
    for ($j = 0; $j -lt $crabArray.Count;$j++) {
        $fuelArray[$i] += $triangleArray[[Math]::Abs($crabArray[$j] - $i)]
    }
}


Write-Host $($fuelArray | Sort)[0]