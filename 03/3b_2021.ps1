<#
Find Oxygen and Carbon Dioxide rates
#>

$strarray = Get-Content inb.txt
$linecount = $strarray.Length
$bitcount = $strarray[0].Length
$oxyhash = @{}
$carbhash = @{}
$onecount = New-Object int[] $bitcount

<#init onecount
for ($i = 0; $i -lt $bitcount;$i++) {
    $onecount[$i] = 0
}#>

#Build hashtables of entries
foreach ($line in $strarray) {
    <#for ($i = 0;$i -lt $bitcount;$i++) {
        if ($line[$i] -eq "1") {
            $onecount[$i]++
        }
    }#>
    $oxyhash[$line] = $null
}
$carbhash = $oxyhash.Clone()

$oxysearch = $true
$carbsearch = $true
for ($i = 0; $i -lt $bitcount; $i++) {

    #Flag to stop removing entries when only one left
    if ($oxyhash.Count -eq 1) {
        $oxysearch = $false
    }
    if ($carbhash.Count -eq 1) {
        $carbsearch = $false
    }
    
    $oxykeys = $oxyhash.Clone().Keys
    if ($oxysearch) {
        $oxyCommon = 0
        foreach ($entry in $oxykeys) {
            if ($entry[$i] -eq "1") {
                $oxyCommon++
            }
        }
        if ($oxyCommon -ge ($oxykeys.Count/2)) {
            $oxySearchTerm = "1"
        } else { $oxySearchTerm = "0" }

        foreach ($key in $oxykeys) {
            if ($oxySearchTerm -ne $key[$i]) {
                $oxyhash.Remove($key)
            }
        }
    }

    $carbkeys = $carbhash.Clone().Keys
    if ($carbsearch) {
        $carbCommon = 0
        foreach ($entry in $carbkeys) {
            if ($entry[$i] -eq "1") {
                $carbCommon++
            }
        }
        if ($carbCommon -ge ($carbkeys.Count/2)) {
            $carbSearchTerm = "0"
        } else { $carbSearchTerm = "1" }

        foreach ($key in $carbkeys) {
            if ($carbSearchTerm -ne $key[$i]) {
                $carbhash.Remove($key)
            }
        }
    }
    
}

$oxyrate = 0
$carbrate = 0
for ($i = 0; $i -lt $bitcount; $i++) {
    $power = $bitcount - 1 - $i
    if (([String] $oxyhash.Keys)[$i] -eq "1") {
        $oxyrate += [Math]::Pow(2,$power)
    }
    if (([String] $carbhash.Keys)[$i] -eq "1") {
        $carbrate += [Math]::Pow(2,$power)
    }
}

Write-Host $oxyrate $oxyhash.Keys
Write-Host $carbrate $carbhash.Keys

Write-Host $($oxyrate * $carbrate)
