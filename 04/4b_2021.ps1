<#
Find winning bingo board
#>

$boardsize = 5

Function Write-Board {
    Param (
        [int[]] $board
    )

    $x = 0
    foreach($int in $board) {
        Write-Host -NoNewline $int " "
        $x++
        if ($x -eq 5) {
            $x = 0
            Write-Host ""
        }
    }
}

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

$i = 0
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

$loserCount = $boardArray.Count
$boardlength = $boardArray[0].Count
$check = $false
for ( ; $i -lt $numbers.Count;$i++) {
    for ($j = 0; $j -lt $boardArray.Count;$j++) {
        if ($boardArray[$j] -ne $null) {
            $check = Check-Board $boardArray[$j]

            if ($check) {
                $boardArray[$j] = $null
                $loserCount--
            }
        }
    }
    if ($loserCount -eq 1) {
        break
    }

    for ($x = 0; $x -lt $boardArray.Count;$x++) {
        if ($boardArray[$x] -ne $null) {
            for ($y = 0; $y -lt $boardlength;$y++) {
                if ([int]$boardArray[$x][$y] -eq [int]$numbers[$i]) {
                    $boardArray[$x][$y] = -1
                }
            }
        }
    }
}

$loserBoard = $null
foreach ($line in $boardArray) {
    if ($line -ne $null) {
        $loserBoard = $line
    }
}

$check = $false
While (!$check) {
    for ($x = 0; $x -lt $loserBoard.Count;$x++) {
        if ($loserBoard[$x] -eq $numbers[$i]) {
            $loserBoard[$x] = -1
        }
    }

    $check = Check-Board $loserBoard
    $i++
}

#Decrement number called since loops goes one past
$i--

$sum = 0
#Sum winning board
foreach ($num in $loserBoard) {
    if ($num -gt 0) {
        $sum += $num
    }
}

Write-Host $numbers[$i] $sum
Write-Host $([int] $numbers[$i] * $sum)
