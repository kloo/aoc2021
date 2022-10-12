<#
99999999999999 too high
99999998565446 running
99999998469451 running
99999985862791 running
#>
date

$strarray = Get-Content inb_t1.txt
$currIndex = 0

#$inputNum = @(14)
#$inputNum = @(9) * 14
$inputNum = @(9,9,9,9,9,9,9,8,4,6,9,4,5,1)

while ($true) {
    $vars = @(0) * 4 #w,x,y,z

    foreach ($line in $strarray) {
        $command = $line.Split(" ")
        $varOne = -1
        $varTwoVal = -1

        Switch ($command[1]) {
            "w" {$varOne = 0; Break}
            "x" {$varOne = 1; Break}
            "y" {$varOne = 2; Break}
            "z" {$varOne = 3; Break}
        }

        $currOp = $command[0]
        if ($currOp -eq "inp") {
            $vars[$varOne] = $inputNum[$currIndex]
            $currIndex++
        } else {
            $varOneVal = $vars[$varOne]

            Switch ($command[2]) {
                "w" {$varTwoVal = $vars[0]; Break}
                "x" {$varTwoVal = $vars[1]; Break}
                "y" {$varTwoVal = $vars[2]; Break}
                "z" {$varTwoVal = $vars[3]; Break}
                Default { $varTwoVal = [int] $command[2] }
            }

            if ($currOp -eq "add") {
                $vars[$varOne] = $varOneVal + $varTwoVal
            } elseif ($currOp -eq "mul") {
                $vars[$varOne] = $varOneVal * $varTwoVal
            } elseif ($currOp -eq "div") {
                $vars[$varOne] = [int] [Math]::Floor($varOneVal / $varTwoVal)
            } elseif ($currOp -eq "mod") {
                $vars[$varOne] = $varOneVal % $varTwoVal
            } elseif ($currOp -eq "eql") {
                if ($varOneVal -eq $varTwoVal) {
                    $vars[$varOne] = 1
                } else {
                    $vars[$varOne] = 0
                }
            }
        }

        #Write-Host "$line --- $vars"
    }

    if ($vars[3] -eq 0) {
        break
    }

    #Decrement input number until no zeroes
    $inputNum[$inputNum.Count - 1]--
    while($inputNum.Contains(0)) {
        $whereZero = $inputNum.IndexOf(0)

        if ($whereZero -eq 0) {
            Write-Host "ERROR! HIT 0 IN MOST SIGNIFICANT DIGIT"
            return 0
        } else {
            $inputNum[$whereZero] = 9
            $inputNum[$whereZero - 1]--
        }
    }

}

"$inputNum".Replace(" ","")
date