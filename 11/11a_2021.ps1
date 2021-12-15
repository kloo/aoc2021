<#

#>


$strarray = Get-Content ina.txt
$size = $strarray[0].Length
$steps = 4

$octoTable = @{}
$flashes = 0

for ($i = 0;$i -lt $size;$i++) {
    for ($j = 0;$j -lt $size;$j++) {
        $num = [int] $strarray[$i].Substring($j,1)
        $octoTable.Add("$j,$i",$num)
    }
}

$stepCount = 0
$keyList = $octoTable.Keys.Clone()
while ($stepCount -lt $steps) {
    foreach ($key in $keylist) { #inc all energy levels by 1
        $octoTable[$key] = $octoTable[$key] + 1
    }

    $toFlashTable = @{}
    $flashedTable = @{}
    $currFlashes = 0
    
    for ($i = 0;$i -lt $size;$i++) { #check for flashes and 
        for ($j = 0;$j -lt $size;$j++) {
            $pos = "$j,$i"
            if ($octoTable[$pos] -gt 9) { #Any octopus with Val > 9 flashes
                $toFlashTable.Add($pos,$null)
            }
        }
    }

    while ($toFlashTable.Count -ne 0) { #increment flash adjacents and see if any need to also flash
        $nextFlashTable = @{}

        foreach ($key in $toFlashTable.Keys) {

            $pos = [int[]] $key.Split(",")

            for ($xInc = -1;$xInc -le 1;$xInc++) {
                for ($yInc = -1;$yInc -le 1;$yInc++) {
                    $currX = $pos[0] + $xInc
                    $currY = $pos[1] + $yInc
                    if (($xInc -eq 0) -and ($yInc -eq 0)) {
                        continue
                    } elseif (($currX -lt 0) -or ($currX -ge $size)) {
                        continue
                    } elseif (($currY -lt 0) -or ($currY -ge $size)) {
                        continue
                    } else {
                        $changePos = "$currX,$currY"

                        if ($octoTable[$changePos] -eq 9) {
                            if (!$flashedTable.ContainsKey($changePos)) { #Value must be flashed
                                $nextFlashTable.Add($changePos,$null)
                            }
                        }
                        $octoTable[$changePos] = $octoTable[$changePos] + 1
                    }
                }
            }

            $flashedTable.Add($key,$null)
        }

        $toFlashTable = $nextFlashTable.Clone()
    }

    $flashes += $flashedTable.Count

    foreach ($key in $flashedTable.Keys) {
        $octoTable[$key] = 0
    }

    $stepCount++
}

Write-Host $flashes