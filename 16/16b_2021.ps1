<#
2729900714438 too high
1549037893818 too high
1549026292886 correct
#>

$inputFile = "inb.txt"
$strarray = Get-Content $inputFile
$answer = 0

$dataSize = $strarray.Length

Function Parse-Packet {
    Param (
        [int64] $startIndex,
        [boolean] $isSubPacket
    )
    $currIndex = $startIndex

    $headerBytes = $binaryString.Substring($currIndex,6)

    $returnVal = [int64] 0
    $currType = [convert]::ToInt64($headerBytes.Substring(3,3),2)

    $currIndex += 6

    if ($currType -eq 4) { #Literal Value packet, search until 0 prefix
        $currBinary = ""

        while ("$($binaryString.Substring($currIndex,1))" -ne "0") {
            $currBinary += $binaryString.Substring($currIndex + 1,4)
            $currIndex += 5
        }

        $currBinary += $binaryString.Substring($currIndex + 1,4)
        $currIndex += 5 #Remove last data packet

        $returnVal = [convert]::ToInt64($currBinary,2)

        #Write-Host "$currBinary $returnVal"
        if (!$isSubPacket) { #Remove end padding 0s
            $endPadding = $currIndex % 8
            if ($endPadding -ne 0) {
                $currIndex += 8 - $endPadding
            }
        }
    } else { #operator packet
        
        $currLID = $binaryString.SubString($currIndex,1)
        $currIndex += 1
        $subPacketVals = New-Object -TypeName "System.Collections.ArrayList"

        if ($currLID -eq "0") { #Next 15 bits are a number that represents total length in bits of the sub-packets in this packet
            
            $currLen = [convert]::ToInt64( ($binaryString.Substring($currIndex,15)) ,2)
            $currIndex += 15

            
            $endIndex = $currIndex + $currLen

            while ($currIndex -lt $endIndex) {
                $currIndex,$subVal = Parse-Packet $currIndex $true
                $subPacketVals += $subVal
            }

            if (!$isSubPacket) { #Remove end padding 0s
                $endPadding = $endIndex % 8
                if ($endPadding -ne 0) {
                    $endIndex += 8 - $endPadding
                }
            }

            $currIndex = $endIndex

        } else { #Next 11 bits are a number that represents the number of sub-packets in this packet
            
            $currLen = [convert]::ToInt64($binaryString.Substring($currIndex,11),2)
            $currIndex += 11

            $subpacketCount = 0
            
            while ($subpacketCount -lt $currLen) {
                
                $currIndex,$subVal = Parse-Packet $currIndex $true
                $subPacketVals += $subVal

                $subpacketCount++
            }

            if (!$isSubPacket) {
                #Remove end padding 0s
                $endPadding = $currIndex % 8
                if ($endPadding -ne 0) {
                    $currIndex += 8 - $endPadding
                }
            }
        }
        
        #Write-Host $currType
        if ($currType -eq 0) { #Sum
            $returnVal = ($subPacketVals | Measure-Object -Sum).Sum
        } elseif ($currType -eq 1) { #Product
            $returnVal = 1
            foreach ($value in $subPacketVals) {
                $returnVal *= $value
            }
        } elseif ($currType -eq 2) { #Minimum
            $returnVal = ($subPacketVals | Measure-Object -Minimum).Minimum
        } elseif ($currType -eq 3) { #Maximum
            $returnVal = ($subPacketVals | Measure-Object -Maximum).Maximum
        } elseif ($currType -eq 5) { #Greater Than
            if ($subPacketVals[0] -gt $subPacketVals[1]) {
                $returnVal = 1
            } else { $returnVal = 0 }
        } elseif ($currType -eq 6) { #Less Than
            if ($subPacketVals[0] -lt $subPacketVals[1]) {
                $returnVal = 1
            } else { $returnVal = 0 }
        } elseif ($currType -eq 7) { #Equal To
            if ($subPacketVals[0] -eq $subPacketVals[1]) {
                $returnVal = 1
            } else { $returnVal = 0 }
        }
    }

    return @($currIndex,$returnVal)
}

Function Test-Func {
    $binaryString
}

#Convert Hex String to Binary
$binaryString = ""
for ($i = 0;$i -lt $dataSize;$i++) {
    $currString = [System.Convert]::ToString("0x$($strarray[$i])",2)

    while ($currString.Length -lt 4) {
        $currString = "0" + $currString
    }

    $binaryString += $currString
}

#Parse Packets
$dataSize = $binaryString.Length
$i = 0
while ($i -lt ($dataSize - 5)) {

    #Write-Host $i
    $i, $addToAnswer = Parse-Packet $i $false
    $answer = $addToAnswer

    #Test-Func
}

Write-Host $answer
