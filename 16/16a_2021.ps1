<#

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

    $currVersion = [convert]::ToInt64($headerBytes.Substring(0,3),2)
    $currType = [convert]::ToInt64($headerBytes.Substring(3,3),2)

    $currIndex += 6

    if ($currType -eq 4) { #Literal Value packet, search until 0 prefix
        while ("$($binaryString.Substring($currIndex,1))" -ne "0") {
            $currIndex += 5
        }

        $currIndex += 5 #Remove last data packet

        if (!$isSubPacket) { #Remove end padding 0s
            $endPadding = $currIndex % 8
            if ($endPadding -ne 0) {
                $currIndex += 8 - $endPadding
            }
        }
    } else { #operator packet
        
        $currLID = $binaryString.SubString($currIndex,1)
        $currIndex += 1

        if ($currLID -eq "0") { #Next 15 bits are a number that represents total length in bits of the sub-packets in this packet
            
            $currLen = [convert]::ToInt64( ($binaryString.Substring($currIndex,15)) ,2)
            $currIndex += 15

            
            $endIndex = $currIndex + $currLen

            while ($currIndex -lt $endIndex) {
                $currIndex,$subVersion = Parse-Packet $currIndex $true
                $currVersion += $subVersion
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
                
                $currIndex,$subVersion = Parse-Packet $currIndex $true
                $currVersion += $subVersion

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
        
    }

    return @($currIndex,$currVersion)
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
    $answer += $addToAnswer

    #Test-Func
}


Write-Host $answer
