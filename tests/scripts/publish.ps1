# Publishes all.

param (
    [Parameter(Mandatory = $false)] [string]$config = 'release'
)

function Get-SolutionRoot() {
    $path = Split-Path -Parent $Script:MyInvocation.MyCommand.Path
    # If no ".git" folder can be found, return the parent folder. By convention, this test helper should be in a first-level subdirectory.
    # Start search in parent folder.
    $parentPath = $path = $(Get-Item $path).Parent.FullName

    while ($true) {
        if (!([string]::IsNullOrEmpty($path))) {
            # $gitFolder = Get-ChildItem -Path $path  -Filter *.git -Recurse -Force
            $gitFolder = Get-ChildItem -Path $path  -Filter *.git -Force
            if ($null -ne $gitFolder) {
                return $gitFolder.Parent.FullName
            }
            else {
                $path = $(Get-Item $path).Parent.FullName
            }
        }
        else {
            # return $PSScriptRoot
            return $parentPath
            break
        }
    }
}

# Set working directory to the script directory.
Push-Location $(Get-SolutionRoot)

try {
    # Publish all assemblies.
    if ($config -eq "debug") {
        $file = ".\publish-debug.ps1"
    }
    else {
        $file = ".\publish.ps1"
    }

    $projects = @(
        # WebApps
        ".\src\api\"
        ".\src\IdentityServer\"
        ".\src\WeatherForecast\"
        ".\src\WebClient\"

        # common
        ".\src\MyBinaryModule\"
    )

    $errors = 0

    foreach ($folder in $projects) {
        Write-Host -ForegroundColor Cyan "Processing folder $folder."
        Push-Location $folder
        try {
            & $file
            if ($LASTEXITCODE -ne 0) {
                $errors += 1
                Write-Host -ForegroundColor Yellow "Processing folder $folder was not successful (build error occurred)."
            }
        }
        catch {
            $errors += 1
            Write-Host -ForegroundColor Yellow "Processing folder $folder was not successful (exception occurred)."
            Write-Host $_
        }
        finally {
            Pop-Location
            Write-Host -ForegroundColor Cyan "Processing folder $folder finished."
            Write-Host ""
        }
    }

    Write-Host -ForegroundColor Cyan "Publish script finished."
    if ($errors -ne 0) {
        Write-Host ""
        Write-Host -ForegroundColor Yellow "Errors occurred during the publishing. See output above for details."
        Write-Host -ForegroundColor Yellow "Build failed for $errors projects."
        # Pass error to caller.
        exit 1
    } else {
        Write-Host -ForegroundColor Cyan "No build processes failed."
        exit 0
    }
} catch {
    Write-Host $_
    exit 1
} finally {
    # Reset the working directory.
    Pop-Location
}
