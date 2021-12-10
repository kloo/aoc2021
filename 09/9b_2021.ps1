<#

#>

$strarray = Get-Content inb.txt
$answer = 0

$mapwidth = $strarray[0].Length
$mapheight = $strarray.Count

$lowTable = @{}

for ($x = 0; $x -lt $mapwidth;$x++) {
    for ($y = 0;$y -lt $mapheight;$y++) {
        $point = $true

        $currHeight = [int] $strarray[$y].Substring($x,1)

        $leftX = $x - 1
        $rightX = $x + 1

        $upY = $y - 1
        $downY = $y + 1

       
        
        if (!($leftX -lt 0)) { # not left col, check L
            $checkHeight = [int] $strarray[$y].Substring($leftX,1)
            if ($checkHeight -le $currHeight) { #check R
                $point = $false
            }
        }
        
        if (!($rightX -eq $mapwidth)) { # not right col, check R
            $checkHeight = [int] $strarray[$y].Substring($rightX,1)
            if ($checkHeight -le $currHeight) { #check R
                $point = $false
            }
        }
        
        if (!($upY -lt 0)) { # not top row, check U
            $checkHeight = [int] $strarray[$upY].Substring($x,1)
            if ($checkHeight -le $currHeight) {
                $point = $false
            }
        }
        
        if (!($downY -eq $mapheight)) { # not bottom row, check D
            $checkHeight = [int] $strarray[$downY].Substring($x,1)
            if ($checkHeight -le $currHeight) {
                $point = $false
            }
        }

        if ($point) {
            $lowTable.Add("$x,$y",$currHeight)
        }
    }
}

$basinSize = New-Object -Typename "System.Collections.ArrayList"

foreach ($key in $lowTable.Keys) {
    $currIndex = 0
    $endIndex = 1
    $basinQueue = New-Object String[] ($mapwidth * $mapheight)
    $basinQueue[$currIndex] = $key

    $basinHashCheck = @{}
    $basinHashCheck.Add($key,$lowTable[$key])

    while ($currIndex -lt $endIndex) {
        
        $x = [int] $basinQueue[$currIndex].Split(",")[0]
        $y = [int] $basinQueue[$currIndex].Split(",")[1]

        $currHeight = [int] $basinHashCheck[$basinQueue[$currIndex]]


        $leftX = $x - 1
        $rightX = $x + 1
        $upY = $y - 1
        $downY = $y + 1
        
        if (!($leftX -lt 0)) { # not left col, check L
            $checkHeight = [int] $strarray[$y].Substring($leftX,1)
            if ($checkHeight -gt $currHeight) { #check R
                if ($checkHeight -ne 9) {
                    $currKey = "$leftX,$y"
                    if (!($basinHashCheck.ContainsKey($currKey))) {
                        $basinQueue[$endIndex] = $currKey
                        $basinHashCheck.Add($currKey,$checkHeight)
                        $endIndex++
                    }

                }
            }
        }
        
        if (!($rightX -eq $mapwidth)) { # not right col, check R
            $checkHeight = [int] $strarray[$y].Substring($rightX,1)
            if ($checkHeight -gt $currHeight) { #check R
                if ($checkHeight -ne 9) {
                    $currKey = "$rightX,$y"
                    if (!($basinHashCheck.ContainsKey($currKey))) {
                        $basinQueue[$endIndex] = $currKey
                        $basinHashCheck.Add($currKey,$checkHeight)
                        $endIndex++
                    }
                }
            }
        }
        
        if (!($upY -lt 0)) { # not top row, check U
            $checkHeight = [int] $strarray[$upY].Substring($x,1)
            if ($checkHeight -gt $currHeight) {
                if ($checkHeight -ne 9) {
                    $currKey = "$x,$upY"
                    if (!($basinHashCheck.ContainsKey($currKey))) {
                        $basinQueue[$endIndex] = $currKey
                        $basinHashCheck.Add($currKey,$checkHeight)
                        $endIndex++
                    }
                }
            }
        }
        
        if (!($downY -eq $mapheight)) { # not bottom row, check D
            $checkHeight = [int] $strarray[$downY].Substring($x,1)
            if ($checkHeight -gt $currHeight) {
                if ($checkHeight -ne 9) {
                    $currKey = "$x,$downY"
                    if (!($basinHashCheck.ContainsKey($currKey))) {
                        $basinQueue[$endIndex] = $currKey
                        $basinHashCheck.Add($currKey,$checkHeight)
                        $endIndex++
                    }
                }
            }
        }

        $currIndex++
    }

    $basinSize.Add($endIndex) | Out-Null

}

$sortedBasinSize = $basinSize | Sort -Descending

$answer = $sortedBasinSize[0] * $sortedBasinSize[1] * $sortedBasinSize[2]

Write-Host $answer