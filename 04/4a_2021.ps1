<#
Find winning bingo board
#>

$boardsize = 5

Function Check-Board {
    Param (
        [int[]] $board
    )
    $winning = $false
    $sum = 0

    #Check rows
    for ($x = 0;$x -lt $boardsize;$x++) {
        for ($y = 0;$y -lt $boardsize;$y++) {
            $pos = ($x * 5) + $y
            $sum += $board[$pos]
        }

        if($sum -eq -5) {
            $winning = $true
            break
        }
        $sum = 0
    }

    #Check columns
    if (!$winning) {
        for ($x = 0;$x -lt $boardsize;$x++) {
            for ($y = 0;$y -lt $boardsize;$y++) {
                $pos = $x + ($y * 5)
                $sum += $board[$pos]
            }

            if($sum -eq -5) {
                $winning = $true
                break
            }
            $sum = 0
        }
    }

    return $winning
}

$strarray = Get-Content inb.txt
$linecount = $strarray.Length
$boardArray = @()
$answer = 0

$numbers = $strarray[0].Split(",")

for ($i = 2; $i -lt $linecount; $i++) {
    $strarray[$i] = $strarray[$i].Replace("  ", " ")
}

#Read in boards as int[]
$i = 2
$boardNum = 0
$boardArray = New-Object int[][] (($linecount - 1)/6)
while ($i -lt $linecount) {
    $boardArray[$boardNum] = ($strarray[$i] + " " + $strarray[$i+1] + " " + $strarray[$i+2] + " " + $strarray[$i+3] + " " + $strarray[$i+4]).Replace("  "," ").TrimStart().TrimEnd().Split(" ")

    $boardNum++
    $i += 6
}

#Mark off numbers
for ($i = 0; $i -lt 5;$i++) {
    for ($x = 0; $x -lt $boardArray.Count;$x++) {
        for ($y = 0; $y -lt $boardArray[0].Count;$y++) {
            if ($boardArray[$x][$y] -eq $numbers[$i]) {
                $boardArray[$x][$y] = -1
            }
        }
    }
}

$check = $false
for ( ; $i -lt $numbers.Count;$i++) {
    for ($j = 0; $j -lt $boardArray.Count;$j++) {
        $check = Check-Board $boardArray[$j]

        if ($check) {
            break
        }
    }
    if ($check) {
        break
    }

    for ($x = 0; $x -lt $boardArray.Count;$x++) {
        for ($y = 0; $y -lt $boardArray[0].Count;$y++) {
            if ($boardArray[$x][$y] -eq $numbers[$i]) {
                $boardArray[$x][$y] = -1
            }
        }
    }
}

#Decrement number called since loops goes one past
$i--

$sum = 0
#Sum winning board
foreach ($num in $boardArray[$j]) {
    if ($num -gt 0) {
        $sum += $num
    }
}

Write-Host $numbers[$i] $sum
Write-Host $([int] $numbers[$i] * $sum)