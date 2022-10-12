<#

#>

$strarray = Get-Content inb.txt
$answer = 0
$posX = 0
$posY = 0

$width = $strarray[0].Length
$height = $strarray.Count

$positionQueue = [System.Collections.ArrayList]@()
$mapTable = @{}

$currPos = "$posX,$posY"
$positionQueue.Add($currPos) | Out-Null
$mapTable.Add($currPos,0)

while ($positionQueue.Count -gt 0) {
    $currPos = $positionQueue[0].Clone()
    $positionQueue.RemoveAt(0) | Out-NUll

    $posX = [int] ($currPos.Split(",")[0])
    $posY = [int] ($currPos.Split(",")[1])

    $updatePos = $posX + 1 # Check Right
    if ($updatePos -lt $width) {
        $checkPos = "$updatePos,$posY"
        $dangerLevel = $mapTable[$currPos] + ([int] $strarray[$posY].Substring($updatePos,1))

        if ($mapTable.Contains($checkPos)) { # Check if already reached point
            if ($dangerLevel -lt $mapTable[$checkPos]) { # Insert if lower danger level and recalc
                $mapTable[$checkPos] = $dangerLevel
                $positionQueue.Add($checkPos) | Out-Null
            }
        } else {
            $mapTable[$checkPos] = $dangerLevel
            $positionQueue.Add($checkPos) | Out-Null
        }
    }

    $updatePos = $posY + 1 # Check Down
    if ($updatePos -lt $height) {
        $checkPos = "$posX,$updatePos"
        $dangerLevel = $mapTable[$currPos] + ([int] $strarray[$updatePos].Substring($posX,1))

        if ($mapTable.Contains($checkPos)) { # Check if already reached point
            if ($dangerLevel -lt $mapTable[$checkPos]) { # Insert if lower danger level and recalc
                $mapTable[$checkPos] = $dangerLevel
                $positionQueue.Add($checkPos) | Out-Null
            }
        } else {
            $mapTable[$checkPos] = $dangerLevel
            $positionQueue.Add($checkPos) | Out-Null
        }
    }
}

Write-Host $mapTable["$($width - 1),$($height - 1)"]
