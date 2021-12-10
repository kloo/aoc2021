<#

#>

$strarray = Get-Content inb.txt
$answer = 0
$openChars = @("(","[","{","<")
$closeChars = @(")","]","}",">")
$pointCount = @(3,57,1197,25137)

<#for ($i = 0; $i -lt $openChars.Count;$i++) {
    Write-Host $([byte][char]$openChars[$i]) $([byte][char]$closeChars[$i]) $(([byte][char]$openChars[$i]) - ([byte][char]$closeChars[$i]))
}#>

foreach ($line in $strarray) {
    $currIndex = 0
    $lastOpen = [System.Collections.ArrayList]@()
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
                Write-Host $currChar
                $answer += $pointCount[$closeChars.IndexOf("$currChar")]
                break
            }
        }
    }
}

Write-Host $answer