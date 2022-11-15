BeforeAll {
    #Capture database details on our instance
    $SQLInstance = '.'

    $Query = `
    "SELECT [name], [value] 
    FROM sys.configurations
    WHERE [name] IN 
    ('min server memory (MB)', 
    'max server memory (MB)', 
    'cost threshold for parallelism', 
    'max degree of parallelism', 
    'remote query timeout (s)', 
    'backup compression default')"

    $ConfigQueryRes = Invoke-SQLCMD -ServerInstance $SQLInstance -Database 'master' -Query $Query
}

Describe "Instance Configuration on $SQLInstance" -Tag "Integration" {

    It "Remote Query Timeout should be 600" {
        $remotequerytimeout = ($ConfigQueryRes | Where-Object {$_.name -eq 'remote query timeout (s)'}).value
        $remotequerytimeout | Should -Be 600
    }
    It "Backup Compression Default should be set " {
        $backupcompression = ($ConfigQueryRes | Where-Object {$_.name -eq 'backup compression default'}).value
        $backupcompression | Should -Be 0
    }

    It "Minimum Server Memory should be: $minmem" {
        $minmem = ($ConfigQueryRes | Where-Object {$_.name -eq 'min server memory (MB)'}).value
        $minmem | Should -Be 0
    }

    It "Maximum Server Memory should be set" {
        $maxmem = ($ConfigQueryRes | Where-Object {$_.name -eq 'max server memory (MB)'}).value
        $maxmem | Should -BeGreaterThan 2000
    }
    It "Cost Threshold for Parallelism should be 5" {
        $CTP = ($ConfigQueryRes | Where-Object {$_.name -eq 'cost threshold for parallelism'}).value
        $CTP | Should -Be 5
    }
        
    It "Max Degree of Parallelism should be set" {
        $MAXDOP = ($ConfigQueryRes | Where-Object {$_.name -eq 'max degree of parallelism'}).value
        $MAXDOP | Should -BeGreaterOrEqual 0
    }
}