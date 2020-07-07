Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox

# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }

function Get-EnvPath {
    [cmdletbinding()]
    Param()

    #get the path separator character specific to this operating system

    $splitter = [System.IO.Path]::PathSeparator
    Write-Verbose "Validating USER paths"

    #filter out blanks if path ends in a splitter
    [System.Environment]::GetEnvironmentVariable("PATH", "User") -split $splitter |
    Where-Object { $_ } | Foreach-Object {
        # create a custom object based on each path
        Write-Verbose "  $_"
        [pscustomobject]@{
            PSTypeName   = "myEnvPath"
            # Computername = [System.Environment]::MachineName
            # UserName     = [System.Environment]::UserName
            Target       = "User"
            Path         = $_
            Exists       = Test-Path $_
        }
    } #foreach

    Write-Verbose "Validating MACHINE paths"
    [System.Environment]::GetEnvironmentVariable("PATH", "Machine") -split $splitter |
    Where-Object { $_ } | Foreach-Object {
        # create a custom object based on each path
        Write-Verbose "  $_"
        [pscustomobject]@{
            PSTypeName   = "myEnvPath"
            # Computername = [System.Environment]::MachineName
            # UserName     = [System.Environment]::UserName
            Target       = "Machine"
            Path         = $_
            Exists       = Test-Path $_
        }
    } #foreach
} #end function

function Repair-EnvPath {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Path,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		        [ValidateSet("User","Machine")]
        [string]$Target
    )

    Begin {
        Write-Verbose "Starting $($myinvocation.MyCommand)"
        #get the path separator character specific to this operating system
        $splitter = [System.IO.Path]::PathSeparator
    }

    Process {
        Write-Verbose "Removing $path from Target %PATH% setting"
        #get current values as an array
        $paths = [system.environment]::GetEnvironmentVariable("PATH", $Target) -split $splitter
        $Corrected = (($paths).where( { $_ -ne $Path })) -join $splitter
        Write-Verbose "Setting a new value of $corrected"
        #add code support for -WhatIf
        if ($PSCmdlet.ShouldProcess("$Target %Path% variable", "Remove $Path")) {
            [System.Environment]::SetEnvironmentVariable("PATH", $Corrected, $Target)
        }
    }
    End {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
}
# Settings
# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# Zoxide hook
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell) -join "`n"
})

# Aliases
New-Alias which Get-Command
New-Alias l Get-ChildItem
New-Alias git hub

# Functions
function path { $env:PATH.Split([System.IO.Path]::PathSeparator).Where({$_.Length}) }

# git
function gs {git status --short @Args}
function gd {git diff @Args}

# navigation
function .. { Set-Location .. }
function ... { Set-Location ..\.. }

function d {
    $cmd = "lsd -lA"
    if ($env:MOSH_CONNECTION -eq 1) {
        $cmd += " --icon never"
    }
    Write-Verbose $cmd
    Invoke-Expression "${cmd} @Args"
}

function x { exa -laFG --group-directories-first }
