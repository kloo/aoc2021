<#
Convert inb2_(x) to inb2_(x+1) for map pieces
#>

$strarray = Get-Content inb2_8.txt
$outfile = "inb2_9.txt"

foreach ($line in $strarray) {
    $newStr = ""

    for ($i = 0;$i -lt $line.Length;$i++) {
        $char = $line.Substring($i,1)

        if ($char -eq "9") {
            $newChar = 1
        } else {
            $newChar = ([int] $char) + 1
        }

        $newStr = $newStr + "$newChar"
    }

    Write-Output $newStr >> $outfile
}