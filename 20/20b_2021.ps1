<#
7202 too low

18858?
17172
#>

$strarray = Get-Content inb.txt

$loops = 50

$minX = -10 - $loops
$minY = -10 - $loops
$maxX = $strarray[2].Length + 10 + $loops
$maxY = $strarray.Length - 2 + 10 + $loops


$onTable = @{}
$answer = 0

for ($i = 2;$i -lt $strarray.Length;$i++) {
    for ($j = 0;$j -lt $strarray[2].Length;$j++) {
        if ($strarray[$i].Substring($j,1) -eq "#") {
            $onTable.Add("$j,$($i-2)",$null)
        }
    }
}

$strarray = $strarray[0]

$loopCount = 0
while ($loopCount -lt $loops) {
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

    Write-Host $loopCount

    $onTable = $nextTable
    $loopCount++
}

$myCount = 0
for ($i = ($loops * -1);$i -le ($loops + 100);$i++) {
    for ($j = ($loops * -1);$j -le ($loops + 100);$j++) {
        if ($onTable.ContainsKey("$j,$i")) {
            $myCount++
        }
    }
}

Write-Host $myCount