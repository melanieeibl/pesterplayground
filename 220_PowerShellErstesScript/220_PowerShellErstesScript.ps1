function Get-PrimeNumber {
    param (
        [parameter(Mandatory=$true)] [int] $value 
    )

    for ($i = 2; $i -le $value; $i++) {
        $found = $true;
        for ($j = 2; $j -lt $i; $j++) {
            if (($i/$j) -is [int]) {
                $found = $false;
                break;
            }
        }
        if ($found) {
            Write-Host $i;
        }
    }
}

Get-PrimeNumber -value 20
