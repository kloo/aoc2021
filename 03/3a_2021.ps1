<#
Find gamma and epsilon rate
#>

$strarray = Get-Content inb.txt
$answer = 0
$linecount = $strarray.Length
$bitcount = $strarray[0].Length
$gammarate = 0
$epsilonrate = 0
$onecount = New-Object int[] $bitcount

#init onecount
for ($i = 0; $i -lt $bitcount;$i++) {
    $onecount[$i] = 0
}

#Build Gamma and Epsilon Rate
foreach ($line in $strarray) {
    for ($i = 0;$i -lt $bitcount;$i++) {
        if ($line[$i] -eq "1") {
            $onecount[$i]++
        }
    }
}

#Convert binary string to decimal int
for ($i = 0; $i -lt $bitcount; $i++) {
    $power = $bitcount - 1 - $i
    if (([int] $onecount[$i]) -gt ($linecount/2)) {
        $gammarate += [Math]::Pow(2,$power)
    } else {
        $epsilonrate += [Math]::Pow(2,$power)
    }
}

Write-Host $($gammarate*$epsilonrate)
