<#
Discard corrupted lines and get the point values of leftover incomplete lines
#>

$strarray = Get-Content inb.txt
$answer = [System.Collections.ArrayList]@()
$openChars = @("(","[","{","<")
$closeChars = @(")","]","}",">")
$pointCount = @(1,2,3,4)

<#for ($i = 0; $i -lt $openChars.Count;$i++) {
    Write-Host $([byte][char]$openChars[$i]) $([byte][char]$closeChars[$i]) $(([byte][char]$openChars[$i]) - ([byte][char]$closeChars[$i]))
}#>

foreach ($line in $strarray) {
    $currIndex = 0
    $lastOpen = [System.Collections.ArrayList]@()

    $corrupted = $false

    for($i = 0;$i -lt $line.Length;$i++) {
        $currChar = [String] $line[$i]
        if ($openChars.Contains($currChar)) { #Opening bracket
            $lastOpen.Add($currChar) | Out-Null
        } else { #Closing bracket
            $currASCII = [byte][char] $currChar
            $lastASCII = [byte][char] $lastOpen[$lastOpen.Count - 1]
            $diff = $currASCII - $lastASCII

            if (($diff -eq 2) -or ($diff -eq 1)) { #Close last opened bracket
                $lastOpen.RemoveAt($lastOpen.Count - 1)
            } else {
                $lastOpen.RemoveAt($lastOpen.Count - 1)
                $corrupted = $true
            }
        }
    }

    
    if (!$corrupted) {
        $currAnswer = 0

        for($i = $lastOpen.Count - 1;$i -ge 0; $i--) {
            $currChar = [String] $lastOpen[$i]
            $currAnswer = ($currAnswer * 5) + $pointCount[$openChars.IndexOf("$currChar")]
            #Write-Host $currAnswer
        }

        $answer.Add($currAnswer) | Out-Null
    }

}


Write-Host $(($answer | Sort-Object)[$answer.Count/2])