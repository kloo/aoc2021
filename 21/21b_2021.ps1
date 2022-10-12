<#

#>

#offset start by 1 as doing pos 0-9 instead of 1-10
$p1pos = 4 - 1
$p2pos = 8 - 1

$p1wins = [int64] 0
$p2wins = [int64] 0

$dieStart = 1

$answer = 0
$myStack = New-Object -TypeName "System.Collections.ArrayList"

#Push initial p1 possiblities
# 3:1,1,1 4:1,1,2 5:1,1,3
# 4:1,2,1 5:1,2,2 6:1,2,3
# 5:1,3,1 6:1,3,2 7:1,3,3
# 4:2,1,1 5:2,1,2 6:2,1,3
# 5:2,2,1 6:2,2,2 7:2,2,3
# 6:2,3,1 7:2,3,2 8:2,3,3
# 5:3,1,1 6:3,1,2 7:3,1,3
# 6:3,2,1 7:3,2,2 8:3,2,3
# 7:3,3,1 8:3,3,2 9:3,3,3
# 3->1, 4->3, 5->6, 6->7, 7->6 8->3 9->1
$p1pos = ($p1pos + 3) % 10 #$Roll 3
$addScore = $p1pos + 1
$myStack.Add("$addScore,0,$p1pos,$p2pos,False,1") | Out-Null

$p1pos = ($p1pos + 1) % 10 #Roll 4
$addScore = $p1pos + 1
$myStack.Add("$addScore,0,$p1pos,$p2pos,False,3") | Out-Null

$p1pos = ($p1pos + 1) % 10 #Roll 5
$addScore = $p1pos + 1
$myStack.Add("$addScore,0,$p1pos,$p2pos,False,6") | Out-Null

$p1pos = ($p1pos + 1) % 10 #Roll 6
$addScore = $p1pos + 1
$myStack.Add("$addScore,0,$p1pos,$p2pos,False,7") | Out-Null

$p1pos = ($p1pos + 1) % 10 #Roll 7
$addScore = $p1pos + 1
$myStack.Add("$addScore,0,$p1pos,$p2pos,False,6") | Out-Null

$p1pos = ($p1pos + 1) % 10 #Roll 8
$addScore = $p1pos + 1
$myStack.Add("$addScore,0,$p1pos,$p2pos,False,3") | Out-Null

$p1pos = ($p1pos + 1) % 10 #Roll 9
$addScore = $p1pos + 1
$myStack.Add("$addScore,0,$p1pos,$p2pos,False,1") | Out-Null

$loopiter = 0
while ($myStack.Count -gt 0) { #p1Score,$p2Score,$p1pos,$p2pos,$currPlayerOne,$instances

    $stackTop = $myStack.Count - 1

    #Pop
    $currGame = ($myStack[$stackTop]).Split(",")
    $myStack.RemoveAt($stackTop) | Out-Null
    
    #Parse String
    try {
    $p1Score = [int] $currGame[0]
    } catch { Write-Host $currGame $stackTop; return 0}
    $p2Score = [int] $currGame[1]
    $p1pos = [int] $currGame[2]
    $p2pos = [int] $currGame[3]
    $currPlayerOne = $currGame[4]
    $currInstances = [int64] $currGame[5]

    #Start Simulation
    if ($currPlayerOne -eq "True") { #Sim Player One
        $p1pos = ($p1pos + 3) % 10 #$Roll 3
        $newp1Score = $p1Score + $p1pos + 1
        if ($newp1Score -gt 21) {
            $p1wins += $currInstances
        } else { $myStack.Add("$newp1Score,$p2Score,$p1pos,$p2pos,False,$currInstances") | Out-Null }

        $p1pos = ($p1pos + 1) % 10 #$Roll 4
        $newp1Score = $p1Score + $p1pos + 1
        if ($newp1Score -gt 21) {
            $p1wins += $currInstances * 3
        } else { $myStack.Add("$newp1Score,$p2Score,$p1pos,$p2pos,False,$($currInstances * 3)") | Out-Null }

        $p1pos = ($p1pos + 1) % 10 #$Roll 5
        $newp1Score = $p1Score + $p1pos + 1
        if ($newp1Score -gt 21) {
            $p1wins += $currInstances * 6
        } else { $myStack.Add("$newp1Score,$p2Score,$p1pos,$p2pos,False,$($currInstances * 6)") | Out-Null }

        $p1pos = ($p1pos + 1) % 10 #$Roll 6
        $newp1Score = $p1Score + $p1pos + 1
        if ($newp1Score -gt 21) {
            $p1wins += $currInstances * 7
        } else { $myStack.Add("$newp1Score,$p2Score,$p1pos,$p2pos,False,$($currInstances * 7)") | Out-Null }

        $p1pos = ($p1pos + 1) % 10 #$Roll 7
        $newp1Score = $p1Score + $p1pos + 1
        if ($newp1Score -gt 21) {
            $p1wins += $currInstances * 6
        } else { $myStack.Add("$newp1Score,$p2Score,$p1pos,$p2pos,False,$($currInstances * 6)") | Out-Null }

        $p1pos = ($p1pos + 1) % 10 #$Roll 8
        $newp1Score = $p1Score + $p1pos + 1
        if ($newp1Score -gt 21) {
            $p1wins += $currInstances * 3
        } else { $myStack.Add("$newp1Score,$p2Score,$p1pos,$p2pos,False,$($currInstances * 3)") | Out-Null }

        $p1pos = ($p1pos + 1) % 10 #$Roll 9
        $newp1Score = $p1Score + $p1pos + 1
        if ($newp1Score -gt 21) {
            $p1wins += $currInstances
        } else { $myStack.Add("$newp1Score,$p2Score,$p1pos,$p2pos,False,$currInstances") | Out-Null }

    } else { #Sim Player Two
        $p2pos = ($p2pos + 3) % 10 #$Roll 3
        $newp2Score = $p2Score + $p2pos + 1
        if ($newp2Score -gt 21) {
            $p2wins += $currInstances
        } else { $myStack.Add("$p1Score,$newp2Score,$p1pos,$p2pos,True,$currInstances") | Out-Null }

        $p2pos = ($p2pos + 1) % 10 #$Roll 4
        $newp2Score = $p2Score + $p2pos + 1
        if ($newp2Score -gt 21) {
            $p2wins += $currInstances * 3
        } else { $myStack.Add("$p1Score,$newp2Score,$p1pos,$p2pos,True,$($currInstances * 3)") | Out-Null }

        $p2pos = ($p2pos + 1) % 10 #$Roll 5
        $newp2Score = $p2Score + $p2pos + 1
        if ($newp2Score -gt 21) {
            $p2wins += $currInstances * 6
        } else { $myStack.Add("$p1Score,$newp2Score,$p1pos,$p2pos,True,$($currInstances * 6)") | Out-Null }

        $p2pos = ($p2pos + 1) % 10 #$Roll 6
        $newp2Score = $p2Score + $p2pos + 1
        if ($newp2Score -gt 21) {
            $p2wins += $currInstances * 7
        } else { $myStack.Add("$p1Score,$newp2Score,$p1pos,$p2pos,True,$($currInstances * 7)") | Out-Null }

        $p2pos = ($p2pos + 1) % 10 #$Roll 7
        $newp2Score = $p2Score + $p2pos + 1
        if ($newp2Score -gt 21) {
            $p2wins += $currInstances * 6
        } else { $myStack.Add("$p1Score,$newp2Score,$p1pos,$p2pos,True,$($currInstances * 6)") | Out-Null }

        $p2pos = ($p2pos + 1) % 10 #$Roll 8
        $newp2Score = $p2Score + $p2pos + 1
        if ($newp2Score -gt 21) {
            $p2wins += $currInstances * 3
        } else { $myStack.Add("$p1Score,$newp2Score,$p1pos,$p2pos,True,$($currInstances * 3)") | Out-Null }

        $p2pos = ($p2pos + 1) % 10 #$Roll 9
        $newp2Score = $p2Score + $p2pos + 1
        if ($newp2Score -gt 21) {
            $p2wins += $currInstances
        } else { $myStack.Add("$p1Score,$newp2Score,$p1pos,$p2pos,True,$currInstances") | Out-Null }
    }

    $loopiter++
    if (($loopiter % 100000) -eq 0) {
        Write-Host $loopiter
    }
}

if ($p1wins -gt $p2wins) {
    Write-Host $p1wins
} else {
    Write-Host $p2wins
}
