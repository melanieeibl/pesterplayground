Function Get-Devices
{
    Param(
        [string]$computer = “localhost”
    )

    Add-Type -AssemblyName System.ServiceProcess
    [System.ServiceProcess.ServiceController]::GetDevices($computer)
}

# Get-Devices

Add-Type -AssemblyName System.ServiceProcess
[System.ServiceProcess.ServiceController[]]$sc = [System.ServiceProcess.ServiceController]::GetDevices('localhost')
$sc
