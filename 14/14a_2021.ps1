<#
Use ruleset to insert characters up until step 10 and subtract most common char count from least common count
#>

$strarray = Get-Content inb.txt
$answer = 0
$rules = @{}
$stepCount = 10

$startString = $strarray[0]

for ($i = 2;$i -lt $strarray.Length;$i++) {
    $ruleEntries = $strarray[$i].Split(" ")
    $rules.Add($ruleEntries[0],$ruleEntries[2])
}

for ($i = 0; $i -lt $stepCount; $i++) {
    

    for ($stringIter = 0;$stringIter -lt ($startString.Length - 1);$stringIter++) {
        
        $compString = $startString.Substring($stringIter,2)

        if ($rules.ContainsKey($compString)) {
            $startString = $startString.Insert($stringIter + 1,$rules[$compString])
            $stringIter++
        }
    }

}

$charCount = @{}
$charArray = $startString.ToCharArray() | Sort
foreach ($char in $charArray) {
    if ($charCount.Contains($char)) {
        $charCount[$char] = $charCount[$char] + 1
    } else {
        $charCount[$char] = 1
    }
}

$measurement = $charCount.Values | Measure-Object -Maximum -Minimum

Write-Host $($measurement.Maximum - $measurement.Minimum)
