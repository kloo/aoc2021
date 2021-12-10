<#
Find optimal fuel efficiency with triangle number costs, benchmarks around 100ms cold, 25ms hot
#>
$starttime = date

$strarray = Get-Content inb.txt
$crabArray = [int64[]] $strarray.Split(",") | Sort
$average = [int] ($crabArray | Measure-Object -Average).Average
$farCrab = $crabArray[$crabArray.Count - 1]

$fuelArray = New-Object int64[] $($farCrab + 1)

for ($j = 0; $j -lt $fuelArray.Count;$j++) {
    $fuelArray[$j] = 0
}

$best = [int64]::MaxValue
for ($i = $average - 1; $i -le $average + 1;$i++) {
    $sum = 0
    for ($j = 0; $j -lt $crabArray.Count;$j++) {
        $triangleNum = [Math]::Abs($crabArray[$j] - $i)
        $sum += ($triangleNum * ($triangleNum + 1)) / 2
    }
    if ($sum -lt $best) { $best = $sum }
}

Write-Host $best

$endtime = date
Write-Host $($endtime - $starttime)