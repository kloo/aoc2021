<#
Find all numbers
#>

$strarray = Get-Content inb.txt
$answer = 0
$outputFinal = New-Object -Typename "System.Collections.ArrayList"

foreach ($line in $strarray) {
    $input = (($line.Split("|"))[0]).Trim().Split(" ")
    $output = (($line.Split("|"))[1]).Trim().Split(" ")
    $currNum = ""

    $oneMatch = ""
    $fourMatch = ""
    $sevenMatch = ""
    $eightMatch = ""

    foreach ($number in $input) {
        $length = $number.Length
        if ($length -eq 2) {       #1
            $oneMatch = $number
        } elseif ($length -eq 4) { #4
            $fourMatch = $number
        } elseif ($length -eq 3) { #7
            $sevenMatch = $number
        } elseif ($length -eq 7) { #8
            $eightMatch = $number
        }
    }

    foreach ($number in $output) {
        $length = $number.Length
        if ($length -eq 2) {       #1
            $currNum += "1"
            $oneMatch = $number
        } elseif ($length -eq 4) { #4
            $currNum += "4"
            $fourMatch = $number
        } elseif ($length -eq 3) { #7
            $currNum += "7"
            $sevenMatch = $number
        } elseif ($length -eq 7) { #8
            $currNum += "8"
            $eightMatch = $number
        } else {
            $currNum += "*"
        }
    }
    
    $twoMatch = ""
    $threeMatch = ""
    $fiveMatch = ""
    $sixMatch = ""
    $nineMatch = ""
    $zeroMatch = ""

    $loopCount = 0
    $currCheck = 0
    while ($currNum.Contains("*")) {
        for ($currCheck = 0; $currCheck -lt $currNum.Length;$currCheck++) {
            $toDecode = $output[$currNum.IndexOf("*",$currCheck)]
            if ($currNum.IndexOf("*",$currCheck) -lt 0) {
                continue
            }
            $match = $false

            if ($toDecode.Length -eq 5) { ######### 2,3,5 #########

                if ($oneMatch -ne "") { #Find 3 by matching with 1
                    $matchCount = 0
                    for ($i = 0; $i -lt $oneMatch.Length;$i++) {
                        if($toDecode.Contains($oneMatch.Substring($i,1))) {
                            $matchCount++
                        }
                    }
                    if ($matchCount -eq 2) {
                        $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "3" + $currNum.Substring($currNum.IndexOf("*") + 1)
                        $threeMatch = $toDecode
                        $match = $true
                    }
                } elseif ($sevenMatch -ne "") { #Find 3 by matching with 7
                    $matchCount = 0
                    for ($i = 0; $i -lt $sevenMatch.Length;$i++) {
                        if($toDecode.Contains($sevenMatch.Substring($i,1))) {
                            $matchCount++
                        }
                    }
                    if ($matchCount -eq 3) {
                        $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "3" + $currNum.Substring($currNum.IndexOf("*") + 1)
                        $threeMatch = $toDecode
                        $match = $true
                    }
                }

                if ((!$match) -and ($fourMatch -ne "")) { #Find 2 or 5 by match with 4
                    $matchCount = 0
                    for ($i = 0; $i -lt $fourMatch.Length;$i++) {
                        if($toDecode.Contains($fourMatch.Substring($i,1))) {
                            $matchCount++
                        }
                    }
                    if ($matchCount -eq 3) { #matches 5 or 3 TODO: Don't assume 5
                            $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "5" + $currNum.Substring($currNum.IndexOf("*") + 1)
                            $fiveMatch = $toDecode
                            $match = $true
                    } else { #Set 2
                        $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "2" + $currNum.Substring($currNum.IndexOf("*") + 1)
                        $twoMatch = $toDecode
                        $match = $true
                    }
                }

            } elseif ($toDecode.Length -eq 6) { ######### 0,6,9 #########
                if ($oneMatch -ne "") { #Find 6 by negative matching with 1
                    $matchCount = 0
                    for ($i = 0; $i -lt $oneMatch.Length;$i++) {
                        if($toDecode.Contains($oneMatch.Substring($i,1))) {
                            $matchCount++
                        }
                    }
                    if ($matchCount -eq 1) {
                        $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "6" + $currNum.Substring($currNum.IndexOf("*") + 1)
                        $sixMatch = $toDecode
                        $match = $true
                    }
                } elseif ($sevenMatch -ne "") { #Find 6 by negative matching with 7
                    $matchCount = 0
                    for ($i = 0; $i -lt $sevenMatch.Length;$i++) {
                        if($toDecode.Contains($sevenMatch.Substring($i,1))) {
                            $matchCount++
                        }
                    }
                    if ($matchCount -eq 2) {
                        $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "6" + $currNum.Substring($currNum.IndexOf("*") + 1)
                        $sixMatch = $toDecode
                        $match = $true
                    }
                }

                if ((!$match) -and ($fourMatch -ne "")) { #Find 9 by match with 4
                    $matchCount = 0
                    for ($i = 0; $i -lt $fourMatch.Length;$i++) {
                        if($toDecode.Contains($fourMatch.Substring($i,1))) {
                            $matchCount++
                        }
                    }
                    if ($matchCount -eq 4) {
                        $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "9" + $currNum.Substring($currNum.IndexOf("*") + 1)
                        $nineMatch = $toDecode
                        $match = $true
                    }
                }

                if (!$match) { #TODO: Don't assume 0, but try it
                    $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "0" + $currNum.Substring($currNum.IndexOf("*") + 1)
                    $zeroMatch = $toDecode
                    $match = $true
                }
            }
        }


        $loopCount++
        if($loopCount -gt $currNum.Length) {
            break
        }
    }
    
    if ($currNum.Contains("*")) {
        Write-Host $currNum "1: $oneMatch, 2: $twoMatch, 3: $threeMatch, 4: $fourMatch, 5: $fiveMatch, 6: $sixMatch, 7: $sevenMatch, 8: $eightMatch, 9: $nineMatch, 0: $zeroMatch "
    }
    $currindex = $OutputFinal.Add($currNum)
}

($OutputFinal | Measure-Object -Sum).Sum
