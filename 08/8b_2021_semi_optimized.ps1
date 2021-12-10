<#
Attempt to optimize/cleanup part 2 original implementation by using the given assumption that all digits are represented from the input
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
        } elseif ($length -eq 4) { #4
            $currNum += "4"
        } elseif ($length -eq 3) { #7
            $currNum += "7"
        } elseif ($length -eq 7) { #8
            $currNum += "8"
        } else {
            $currNum += "*"
        }
    }
    
    while ($currNum.Contains("*")) {
            $toDecode = $output[$currNum.IndexOf("*",$currCheck)]
            if ($currNum.IndexOf("*",$currCheck) -lt 0) {
                continue
            }

            $match = $false
            if ($toDecode.Length -eq 5) { ######### 2,3,5 #########

                $matchCount = 0
                for ($i = 0; $i -lt $oneMatch.Length;$i++) { #Find 3 by match with 1
                    if($toDecode.Contains($oneMatch.Substring($i,1))) {
                        $matchCount++
                    }
                }
                if ($matchCount -eq 2) {
                    $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "3" + $currNum.Substring($currNum.IndexOf("*") + 1)
                } else { #Find 2 or 5 by match with 4
                    $matchCount = 0
                    for ($i = 0; $i -lt $fourMatch.Length;$i++) {
                        if($toDecode.Contains($fourMatch.Substring($i,1))) {
                            $matchCount++
                        }
                    }
                    if ($matchCount -eq 3) { #matches 5
                        $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "5" + $currNum.Substring($currNum.IndexOf("*") + 1)
                    } else { #Set 2
                        $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "2" + $currNum.Substring($currNum.IndexOf("*") + 1)
                    }
                }

            } elseif ($toDecode.Length -eq 6) { ######### 0,6,9 #########
                $matchCount = 0
                for ($i = 0; $i -lt $oneMatch.Length;$i++) { #Find 6 by negative matching with 1
                    if($toDecode.Contains($oneMatch.Substring($i,1))) {
                        $matchCount++
                    }
                }
                if ($matchCount -eq 1) {
                    $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "6" + $currNum.Substring($currNum.IndexOf("*") + 1)
                } else { #Find 9 by match with 4
                    $matchCount = 0
                    for ($i = 0; $i -lt $fourMatch.Length;$i++) {
                        if($toDecode.Contains($fourMatch.Substring($i,1))) {
                            $matchCount++
                        }
                    }
                    if ($matchCount -eq 4) { #Matches 9
                        $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "9" + $currNum.Substring($currNum.IndexOf("*") + 1)
                    } else { #Matches 0
                        $currNum = $currNum.Substring(0,$currNum.IndexOf("*")) + "0" + $currNum.Substring($currNum.IndexOf("*") + 1)
                    }
                }
            }
    }
    
    if ($currNum.Contains("*")) {
        Write-Host $currNum "1: $oneMatch, 2: $twoMatch, 3: $threeMatch, 4: $fourMatch, 5: $fiveMatch, 6: $sixMatch, 7: $sevenMatch, 8: $eightMatch, 9: $nineMatch, 0: $zeroMatch "
    }
    $currindex = $OutputFinal.Add($currNum)
}

($OutputFinal | Measure-Object -Sum).Sum
