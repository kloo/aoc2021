<#

#>

$strarray = Get-Content inb.txt
$answer = 0

$mapwidth = $strarray[0].Length
$mapheight = $strarray.Count

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
            Write-Host -NoNewline $currHeight $answer
            $answer += $currHeight + 1
            Write-Host " $answer"
        }
    }
}

Write-Host $answer
