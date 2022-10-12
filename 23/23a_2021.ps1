<#

inb1a
B1 -> Left corner external	  20
C1 -> Right corner internal	1000
A2 -> Inner A			   5
C4 -> Right corner external	 200
A4 -> Outer A (A Done, fig 2)	   9
D2 -> Inner D			8000
B3 -> Inner B			  50
B1 -> Outer B (B Done, fig 3)	  40
D3 -> Outer D (D Done)		5000
C4 -> Inner C			 500
C1 -> Outer C (All Done)	 500
Total: 14 + 110 + 1200 + 14000 = 15324 (Too High)

inb1b
B1 -> Left corner internal	  30
C1 -> Left corner external	 300
A2 -> Inner A			   5
C4 -> Right corner external	 200
A4 -> Outer A (A Done, fig 2)	   9
D2 -> Inner D			8000
B3 -> Inner B			  50
D3 -> Outer D (D Done)		5000
C4 -> Inner C			 500
C1 -> Outer C (All Done)	 600
B1 -> Outer B (B Done, fig 3)	  50
Total: 14 + 130 + 1600 + 13000 = 14744 (Too High)

#>

$strarray = Get-Content ina.txt
$answer = 0

foreach ($line in $strarray) {

}

Write-Host $answer
