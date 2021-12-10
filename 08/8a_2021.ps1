<#
Find easy numbers on seven segment display
#>

$strarray = Get-Content inb.txt
$inputarray = $strarray.Split(",")
$answer = 0

foreach ($line in $strarray) {
    $output = (($line.Split("|"))[1]).Split(" ")
    foreach ($number in $output) { #1
        $length = $number.Length
        if ($length -eq 2) {
            $answer++ 
        } elseif ($length -eq 4) { #4
            $answer++
        } elseif ($length -eq 3) { #7
            $answer++
        } elseif ($length -eq 7) { #8
            $answer++
        }
    }
}

Write-Host $answer
