#escape=`
FROM microsoft/aspnet
LABEL maintainer "Brandon Sedgwick <bmsedgwick@gmail.com>"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Install-WindowsFeature NET-Framework-45-Core ; `
    Install-WindowsFeature NET-Framework-45-ASPNET ; `
    Install-WindowsFeature Web-Asp-Net45

RUN Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco install git -y ; `
  choco install dotnet4.6-targetpack --allow-empty-checksums -y ; `
  choco install nuget.commandline --allow-empty-checksums -y ; `
  choco install microsoft-build-tools -y --allow-empty-checksums -version 12.0.21005.20140416

ADD v12.0/tools C:/tools
RUN mkdir 'C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v12.0' -Force ; `
    mv C:/tools/* 'C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v12.0'

RUN setx /M PATH $($Env:PATH + ';' + ${Env:ProgramFiles(x86)} + '\MSBuild\12.0\Bin')
