<#
Use ruleset to insert characters up until step 40 and subtract most common char count from least common count
#>

$strarray = Get-Content inb.txt
$answer = 0
$rules = @{}
$stepCount = 40

$startString = $strarray[0]

$pairTable = @{}

for ($i = 2;$i -lt $strarray.Length;$i++) {
    $ruleEntries = $strarray[$i].Split(" ")
    $rules.Add($ruleEntries[0],$ruleEntries[2])
}

for ($i = 0;$i -lt ($startString.Length - 1);$i++) {
    $currPair = $startString.Substring($i,2)

    if ($pairTable.ContainsKey($currPair)) {
        $pairTable[$currPair] = $pairTable[$currPair] + 1
    } else {
        $pairTable[$currPair] = 1
    }
}

#$pairTable

for ($i = 0; $i -lt $stepCount; $i++) {
    $tempTable = @{}
    
    foreach ($key in $pairTable.Keys) {

        $currCount = $pairTable[$key]

        if ($rules.Contains($key)) {
            $newString = "$($key[0])$($rules[$key])"
            $endNewString = "$($rules[$key])$($key[1])"
            
            if ($tempTable.ContainsKey($newString)) {
                $tempTable[$newString] += $currCount
            } else {
                $tempTable[$newString] = $currCount
            }

            if ($tempTable.ContainsKey($endNewString)) {
                $tempTable[$endNewString] += $currCount
            } else {
                $tempTable[$endNewString] = $currCount
            }
        } else {
            if ($tempTable.ContainsKey($key)) {
                $tempTable[$key] += $currCount
            } else {
                $tempTable[$key] = $currCount
            }
        }
    }

    $pairTable = $tempTable

    #Write-Host $i $(Get-Date)
}

$charCount = @{}
$charArray = $pairTable.Keys
foreach ($pair in $charArray) {
    $char = $pair.ToCharArray()
    $currCount = $pairTable[$pair]

    if ($charCount.Contains($char[0])) {
        $charCount[$char[0]] = $charCount[$char[0]] + $currCount
    } else {
        $charCount[$char[0]] = $currCount
    }

    if ($charCount.Contains($char[1])) {
        $charCount[$char[1]] = $charCount[$char[1]] + $currCount
    } else {
        $charCount[$char[1]] = $currCount
    }
}

foreach ($char in $charCount.Clone().Keys) {
    $charCount[$char] = [Math]::Ceiling($($charCount[$char] / 2))
}

$measurement = $charCount.Values | Measure-Object -Maximum -Minimum

Write-Host $($measurement.Maximum - $measurement.Minimum)
