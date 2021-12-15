<#

#>

$strarray = Get-Content inb.txt
$coordTable = @{}

$linebreak = $strarray.IndexOf("")

for ($i = 0;$i -lt $linebreak;$i++) {#6,10
    $coordTable.Add($strarray[$i],$null)
}


for ($i = $linebreak+1;$i -lt $strarray.Count;$i++) { #fold along y=7

    $action = ($strarray[$i].Split(" "))[2].Split("=")
    $horizontalFold = $false
    if ($action[0] -eq "y") {
        $horizontalFold = $true
    }

    $keylist = $coordTable.Clone().Keys
    foreach ($key in $keylist) {
        $coords = [int[]] $key.Split(",")

        $checkCoord = -1
        if ($horizontalFold) {
            $checkCoord = $coords[1]
        } else { $checkCoord = $coords[0] }

        $actionLine = [int] $action[1]
        if ($checkCoord -eq $actionLine) { #if point is on the fold line
            $coordTable.Remove($key)
        } elseif ($checkCoord -gt $actionLine) {
            $coordTable.Remove($key)
            $checkCoord = $checkCoord - (($checkCoord - $actionLine)*2)

            if ($horizontalFold) {
                $newCoord = "$($coords[0]),$($checkCoord)"
            } else {
                $newCoord = "$($checkCoord),$($coords[1])"
            }

            if (!$coordTable.Contains($newCoord)) {
                $coordTable.Add($newCoord,$null)
            }
        }
    }
}

<# Doesn't work?
foreach ($key in $coordTable.Keys) {
    $maxX = 0
    $maxY = 0

    $coords = [int[]] $key.Split(",")

    if ($maxX -lt $coords[0]) {
        $maxX = $coords[0]
    }

    if ($maxY -lt $coords[1]) {
        $maxY = $coords[1]
        Write-Host $maxY
    }
} #>

$maxX = 35
$maxY = 5

$emptyArray = " " * $($maxX * 2)
$twoDimArray = New-Object String[] ($maxY + 1)
for ($i = 0; $i -le $maxY;$i++) {
    $twoDimArray[$i] = $emptyArray
}

foreach ($key in $coordTable.Keys) {
    $coords = [int[]] $key.Split(",")
    $twoDimArray[$coords[1]] = $twoDimArray[$coords[1]].Insert($coords[0],"#").Remove($coords[0] + 1,1)
}

Write-Host $maxX $maxY
