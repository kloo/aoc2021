<#
Find overlapping danger zones
#>

$strarray = Get-Content inb.txt
$linecount = $strarray.Length
$ventHash = @{}
$dangerCount = 0

foreach ($line in $strarray) {
    $points = $line.Split(" ")
    $startCoords = [int[]] $points[0].Split(",")
    $endCoords = [int[]] $points[2].Split(",")

    #Vertical line
    if ($startCoords[0] -eq $endCoords[0]) {
        $fixedX = $startCoords[0]
        $startY = $startCoords[1]
        $distance = $endCoords[1] - $startCoords[1]

        if ($distance -lt 0) {
            $movement = -1
        } else { $movement = 1 }

        #Insert start point
        if ($ventHash.ContainsKey($points[0])) {
            $ventHash[$points[0]] = $ventHash[$points[0]] + 1
        } else {
            $ventHash.Add($points[0],1)
        }

        for ($i = 0; $i -ne  $distance; $i += $movement) {
            $currCoord = "$($fixedX),$($startY + $i + $movement)"
            if ($ventHash.ContainsKey($currCoord)) {
                $ventHash[$currCoord] = $ventHash[$currCoord] + 1
            } else {
                $ventHash.Add($currCoord,1)
            }
        }

    } elseif ($startCoords[1] -eq $endCoords[1]) { #Horizontal line
        $fixedY = $startCoords[1]
        $startX = $startCoords[0]
        $distance = $endCoords[0] - $startCoords[0]

        if ($distance -lt 0) {
            $movement = -1
        } else { $movement = 1 }

        #Insert start point
        if ($ventHash.ContainsKey($points[0])) {
            $ventHash[$points[0]] = $ventHash[$points[0]] + 1
        } else {
            $ventHash.Add($points[0],1)
        }

        for ($i = 0; $i -ne  $distance; $i += $movement) {
            $currCoord = "$($startX + $i + $movement),$($fixedY)"
            if ($ventHash.ContainsKey($currCoord)) {
                $ventHash[$currCoord] = $ventHash[$currCoord] + 1
            } else {
                $ventHash.Add($currCoord,1)
            }
        }

    } else { #Diagonal line
        $startX = $startCoords[0]
        $startY = $startCoords[1]
        $distanceX = $endCoords[0] - $startCoords[0]
        $distanceY = $endCoords[1] - $startCoords[1]

        if ($distanceX -lt 0) {
            $movementX = -1
        } else { $movementX = 1 }

        if ($distanceY -lt 0) {
            $movementY = -1
        } else { $movementY = 1 }

        #Insert start point
        if ($ventHash.ContainsKey($points[0])) {
            $ventHash[$points[0]] = $ventHash[$points[0]] + 1
        } else {
            $ventHash.Add($points[0],1)
        }

        for ($i = 0; $i -lt  ($distanceX * $movementX); $i++) {
            $currCoord = "$($startX + (($i + 1)*$movementX)),$($startY + (($i + 1)*$movementY))"
            if ($ventHash.ContainsKey($currCoord)) {
                $ventHash[$currCoord] = $ventHash[$currCoord] + 1
            } else {
                $ventHash.Add($currCoord,1)
            }
        }
    }
}

foreach ($key in $ventHash.Keys) {
    if ($ventHash[$key] -gt 1) {
        $dangerCount++
    }
}

Write-Host $dangerCount