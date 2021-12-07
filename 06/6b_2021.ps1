<#
Count fish
#>

$strarray = Get-Content inb.txt
$fishArray = [int64[]] $strarray.Split(",")
$dayCount = 256
$newFishTimer = 8
$oldFishTimer = 6
$currFishArray = New-Object int64[] $($newFishTimer + 1)


for ($i = 0; $i -lt $currFishArray.Count;$i++) {
    $currFishArray[$i] = 0
}

foreach ($fish in $fishArray) {
    $currFishArray[$fish]++
}

for ($i = 0; $i -lt $dayCount;$i++) {
    $newFishArray = New-Object int64[] $($newFishTimer + 1)

    for ($j = 8;$j -gt 0;$j--) {
        $newFishArray[$j-1] = $currFishArray[$j]
    }

    $newFishArray[$oldFishTimer] = $currFishArray[0] + $currFishArray[$oldFishTimer+1]
    $newFishArray[$newFishTimer] = $currFishArray[0]

    $currFishArray = $newFishArray
}

$sum = 0
foreach ($fishCount in $currFishArray) {
    $sum += $fishCount
}

Write-Host $sum