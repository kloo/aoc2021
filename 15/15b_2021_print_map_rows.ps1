<#
print map rows of
inb2_1 inb2_2 inb2_3 inb2_4 inb2_5
inb2_2 inb2_3 inb2_3 inb2_4 inb2_5
inb2_3 inb2_4 inb2_5 inb2_6 inb2_7
inb2_4 inb2_5 inb2_6 inb2_7 inb2_8
inb2_5 inb2_6 inb2_7 inb2_8 inb2_9
#>

$start = 5

$fileOne = Get-Content "inb2_$($start).txt"
$fileTwo = Get-Content "inb2_$($start + 1).txt"
$fileThree = Get-Content "inb2_$($start + 2).txt"
$fileFour = Get-Content "inb2_$($start + 3).txt"
$fileFive = Get-Content "inb2_$($start + 4).txt"
$outfile = "line$($start).txt"

for ($i = 0;$i -lt $fileOne.Length;$i++) {
    $mystr = $fileOne[$i] + $fileTwo[$i] + $fileThree[$i] + $fileFour[$i] + $fileFive[$i]
    Write-Output $mystr >> $outfile
}