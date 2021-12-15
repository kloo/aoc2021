<#

#>

$strarray = Get-Content inb.txt
$coordTable = @{}

$linebreak = $strarray.IndexOf("")

for ($i = 0;$i -lt $linebreak;$i++) {#6,10
    $coordTable.Add($strarray[$i],$null)
}

<#
for ($i = $linebreak+1;$i -lt $strarray.Count;$i++) { #fold along y=7
    $action = ($strarray[$i].Split(" "))[2].Split("=")
}#>

$action = ($strarray[$linebreak + 1].Split(" "))[2].Split("=")
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

Write-Host $coordTable.Count
