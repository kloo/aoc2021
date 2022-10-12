<#

#>

$strarray = Get-Content inb2.txt
$answer = 0
$onTable = @{}

$counter = 0
foreach ($line in $strarray) {
    Write-Host $(date) $counter
    $counter++
    #$nextTable = $onTable.Clone()

    $procedure = $line.Split(" ")[0]
    $coords = $line.Split(" ")[1].Split("=,")

    $xRange = $coords[1].Split(".")
    $xMin = [int] $xRange[0]
    $xMax = [int] $xRange[2]

    $yRange = $coords[3].Split(".")
    $yMin = [int] $yRange[0]
    $yMax = [int] $yRange[2]

    $zRange = $coords[5].Split(".")
    $zMin = [int] $zRange[0]
    $zMax = [int] $zRange[2]
    
    if ($procedure -eq "on") {
        for ($i = $xMin;$i -le $xMax;$i++) {
            for ($j = $yMin;$j -le $yMax;$j++) {
                for ($k = $zMin;$k -le $zMax;$k++) {
                    $onTable["$i,$j,$k"] = $null
                }
            }
        }
    } else {
        for ($i = $xMin;$i -le $xMax;$i++) {
            for ($j = $yMin;$j -le $yMax;$j++) {
                for ($k = $zMin;$k -le $zMax;$k++) {
                    $onTable.Remove("$i,$j,$k") | Out-Null
                }
            }
        }
    }

    #$onTable = $nextTable.Clone()
}

Write-Host $onTable.Count
