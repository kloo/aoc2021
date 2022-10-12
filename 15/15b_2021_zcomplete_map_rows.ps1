<#
Put together map rows after printing them from print_map_rows
line1
line2
line3
line4
line5
#>

$outfile = "inb2.txt"

for ($i = 1;$i -le 5;$i++) {
    $infile = Get-Content "line$($i).txt"
    Write-Output $infile >> $outfile
}