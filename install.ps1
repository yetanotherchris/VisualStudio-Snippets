# Check for admin
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent())
if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $false)
{
    Write-Error "Please run this scripts as an administrator"
    exit 1
}

Set-ExecutionPolicy RemoteSigned -Confirm:$false -Force
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
refresheenv

# Stop prompting in Chocolately
choco feature enable -n allowGlobalConfirmation

# These commands will install Visual Studio
#choco install visualstudio2017community
#choco install visualstudio2017-workload-netcoretools
#choco install visualstudio2017-workload-netweb

# All the software needed to be a modern website developing programmer engineer
choco install googlechrome
choco install firefox
choco install coneumu
choco install visualstudiocode
choco install linqpad5
choco install 7zip
choco install github
choco install docker-for-windows
choco install curl
choco install terraform
choco install poshgit

# Resharper
choco install resharper-platform -y
$resharperInstaller = Resolve-Path "$env:ChocolateyInstall\lib\resharper-platform\JetBrains.ReSharperUltimate.*.exe"
Write-Output "Installing ReSharper Ultimate with lots of goodies: $resharperInstaller"
Start-Process -FilePath "$resharperInstaller" -ArgumentList "/SpecificProductNames=ReSharper /Silent=True" -Wait -PassThru

# In explorer, show file extensions
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f

# Linux Windows subsystem
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

pushd $env:temp

rm -Force master.zip -ErrorAction Ignore;
rm -Force -Recurse master  -ErrorAction Ignore;
curl.exe -O -k -L https://github.com/yetanotherchris/VisualStudio-VM/archive/master.zip
Expand-Archive ./master.zip -Force
pushd master/VisualStudio-VM-master

# Powershell profile
cp -Force ./profile.ps1 $profile

# Install code snippets
cp -Force snippets/*.* "~\Documents\Visual Studio 2017\Code Snippets\Visual C#\My Code Snippets"; 

# Install the Ubuntu font for Conemu
Expand-Archive ubuntu-font-family-0.83.zip ./ubuntu-fonts

$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
dir ubuntu-fonts\ubuntu-font-family-0.83\*.ttf | foreach-object { $fonts.CopyHere($_.fullname) }

# Install conemu settings
cp -Force ./conemu.xml ~\AppData\Roaming\conemu.xml

# Install VS settings
set-alias devenv "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe" -Scope global
devenv /ResetSettings .\vs2017.vssettings


popd