Add-Type -AssemblyName "$PSScriptRoot\System.Diagnostics.Process.dll"
$procs = [System.Diagnostics.Process]::GetProcesses()
$procs
# $procs.Count

# $procs.GetType()

Get-Process
# $(Get-Process).Count


# using System.Diagnostics;
# var procs = Process.GetProcesses();
# foreach (var process in procs)
#     Console.WriteLine(process);


Get-Command -Name Get-Process | Format-List -Property ModuleName

