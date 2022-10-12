<#
This one doesn't work, see 20a_2021_test.ps1

5431 too high
5348 too high
5322 too low
#>

$strarray = Get-Content inb.txt
$minX = 0
$minY = 0
$maxX = $strarray[2].Length
$maxY = $strarray.Length - 2
$loops = 2

$onTable = @{}
$answer = 0

for ($i = 2;$i -lt $strarray.Length;$i++) {
    for ($j = 0;$j -lt $maxX;$j++) {
        if ($strarray[$i].Substring($j,1) -eq "#") {
            $onTable.Add("$j,$($i-2)",$null)
        }
    }
}

$strarray = $strarray[0]

$loopCount = 0
while ($loopCount -lt $loops) {
    $minX--
    $minY--
    $maxX++
    $maxY++
    $nextTable = @{}

    for ($i = $minY;$i -lt $maxY;$i++) {
        for ($j = $minX;$j -lt $maxX;$j++) {
            $bitString = ""

            for ($k = -1;$k -le 1;$k++) {
                for ($m = -1;$m -le 1;$m++) {
                    $currX = $j + $m
                    $currY = $i + $k

                    

                    if ($onTable.ContainsKey("$currX,$currY")) {
                        $bitString += "1"
                    } else { $bitString += "0" }

                    <#if ($j -eq 2 -and $i -eq 2) {
                        Write-Host "$currX,$currY $bitString"
                    }#>
                }
            }

            $currVal = [convert]::ToInt16($bitString,2)
            $decodeChar = $strarray.Substring($currVal,1)

            <#if ($j -eq 2 -and $i -eq 2) {
                Write-Host "$j,$i $currVal $decodeChar"
            }#>

            if ($decodeChar -eq "#") {
                $nextTable.Add("$j,$i",$null)
            }
            
        }
    }

    #Compensate for whole array blinking by adding padding on even loops (step 1 is $loopcount 0)
    if (($loopCount % 2) -eq 0) {
        for ($i = ($minX - 2);$i -lt ($maxX + 2);$i++) {
            $nextTable.Add("$i,$($minY - 1)",$null)
            $nextTable.Add("$i,$($minY - 2)",$null)
            #$nextTable.Add("$i,$($minY - 3)",$null)

            $nextTable.Add("$i,$($maxY + 1)",$null)
            $nextTable.Add("$i,$($maxY + 2)",$null)
            #$nextTable.Add("$i,$($maxY + 3)",$null)
        }

        for ($i = $minY;$i -le $maxY;$i++) {
            $nextTable.Add("$($minX - 1),$i",$null)
            $nextTable.Add("$($minX - 2),$i",$null)
            #$nextTable.Add("$($minX - 3),$i",$null)

            $nextTable.Add("$($maxX + 1),$i",$null)
            $nextTable.Add("$($maxX + 2),$i",$null)
            #$nextTable.Add("$($maxX + 3),$i",$null)
        }
    }

    $onTable = $nextTable
    $loopCount++
}

Write-Host $onTable.Count
