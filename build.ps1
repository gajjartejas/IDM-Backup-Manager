[CmdletBinding()]
param (
    [ValidateSet('x86', 'x64')]
    [string]$Arch = 'x86',

    [switch]$NoInstaller
)

$ErrorActionPreference = 'Stop'
$ScriptDir = $PSScriptRoot
$SourceFile = Join-Path $ScriptDir "IDM Backup Manager.au3"
$IconFile = Join-Path $ScriptDir "Resources\icon.ico"
$OutputDir = Join-Path $ScriptDir "bin"
$OutputFile = Join-Path $OutputDir "IDM Backup Manager.exe"
$InstallerScript = Join-Path $ScriptDir "Build\installer.iss"
$InstallerOutputFile = Join-Path $OutputDir "IDM_Backup_Manager_Setup.exe"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "         IDM Backup Manager - Build Pipeline" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Locate AutoIt Installation
$AutoItDirs = @(
    "${env:ProgramFiles(x86)}\AutoIt3",
    "${env:ProgramFiles}\AutoIt3"
)

$AutoItRoot = $null
foreach ($dir in $AutoItDirs) {
    if (Test-Path "$dir\Aut2Exe\Aut2exe.exe") {
        $AutoItRoot = $dir
        break
    }
}

if (-not $AutoItRoot) {
    Write-Error "AutoIt3 installation not found! Please install AutoIt v3 from https://www.autoitscript.com/"
    exit 1
}

$Aut2exe = Join-Path $AutoItRoot "Aut2Exe\Aut2exe.exe"
$Au3Check = Join-Path $AutoItRoot "Au3Check.exe"

Write-Host "[OK] Found AutoIt3 at: $AutoItRoot" -ForegroundColor Green

# 2. Syntax Check via Au3Check
Write-Host "[*] Running syntax validation with Au3Check..." -ForegroundColor Yellow
$IncludesDir = Join-Path $ScriptDir "Includes"

$CheckProcess = Start-Process -FilePath $Au3Check -ArgumentList "-I `"$IncludesDir`" `"$SourceFile`"" -NoNewWindow -PassThru -Wait
if ($CheckProcess.ExitCode -ne 0) {
    Write-Error "Au3Check reported errors! Build aborted."
    exit $CheckProcess.ExitCode
}
Write-Host "[OK] Syntax check passed (0 errors)." -ForegroundColor Green

# 3. Create Output Directory & Ensure 7-Zip Dependencies
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

$Dll32 = Join-Path $OutputDir "7-zip32.dll"
$Dll64 = Join-Path $OutputDir "7-zip64.dll"
$ReleaseBase = "https://github.com/gajjartejas/IDM-Backup-Manager/releases/download/v1.1.0"

if (-not (Test-Path $Dll32)) {
    Write-Host "[*] Downloading 7-zip32.dll from release..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri "$ReleaseBase/7-zip32.dll" -OutFile $Dll32 -UseBasicParsing
        Write-Host "[OK] Downloaded 7-zip32.dll" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to download 7-zip32.dll: $_"
    }
}
if (-not (Test-Path $Dll64)) {
    Write-Host "[*] Downloading 7-zip64.dll from release..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri "$ReleaseBase/7-zip64.dll" -OutFile $Dll64 -UseBasicParsing
        Write-Host "[OK] Downloaded 7-zip64.dll" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to download 7-zip64.dll: $_"
    }
}

# 4. Compile Application
# Look for AutoIt3Wrapper (embeds all resources, icons, and metadata)
$WrapperDirs = @(
    "$AutoItRoot\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3",
    "$AutoItRoot\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe"
)
$WrapperPath = $null
foreach ($path in $WrapperDirs) {
    if (Test-Path $path) {
        $WrapperPath = $path
        break
    }
}

# Make sure old output binary is removed to ensure fresh build
if (Test-Path $OutputFile) {
    Remove-Item $OutputFile -Force -ErrorAction SilentlyContinue
}

if ($WrapperPath) {
    Write-Host "[*] Compiling with AutoIt3Wrapper (embedding all resource icons & metadata)..." -ForegroundColor Yellow
    $AutoItExe = Join-Path $AutoItRoot "AutoIt3.exe"
    if ($WrapperPath.EndsWith(".au3")) {
        $CompileProcess = Start-Process -FilePath $AutoItExe -ArgumentList "`"$WrapperPath`" /in `"$SourceFile`"" -NoNewWindow -PassThru -Wait
    } else {
        $CompileProcess = Start-Process -FilePath $WrapperPath -ArgumentList "/in `"$SourceFile`"" -NoNewWindow -PassThru -Wait
    }
} else {
    Write-Host "[*] Compiling $SourceFile ($Arch)..." -ForegroundColor Yellow
    $CompileArgs = "/in `"$SourceFile`" /out `"$OutputFile`""
    if (Test-Path $IconFile) {
        $CompileArgs += " /icon `"$IconFile`""
    }
    if ($Arch -eq 'x64') {
        $CompileArgs += " /x64"
    } else {
        $CompileArgs += " /x86"
    }
    $CompileArgs += " /comp 4"

    $CompileProcess = Start-Process -FilePath $Aut2exe -ArgumentList $CompileArgs -NoNewWindow -PassThru -Wait
}

if (-not (Test-Path $OutputFile)) {
    Write-Error "Compilation failed!"
    exit 1
}

# Ensure Resources folder is also mirrored into output directory for portable / standalone use
$DestResources = Join-Path $OutputDir "Resources"
if (-not (Test-Path $DestResources)) {
    Copy-Item -Path (Join-Path $ScriptDir "Resources") -Destination $OutputDir -Recurse -Force
}

$FileSize = (Get-Item $OutputFile).Length
$FileHash = (Get-FileHash $OutputFile -Algorithm SHA256).Hash

Write-Host "[OK] Application compiled successfully:" -ForegroundColor Green
Write-Host "     Binary: $OutputFile" -ForegroundColor White
Write-Host "     Size  : $([math]::Round($FileSize / 1KB, 2)) KB" -ForegroundColor White
Write-Host "     SHA256: $FileHash" -ForegroundColor White

# 5. Build Windows Setup Installer with Inno Setup
if (-not $NoInstaller -and (Test-Path $InstallerScript)) {
    Write-Host "`n[*] Checking for Inno Setup compiler..." -ForegroundColor Yellow
    $InnoDirs = @(
        "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe",
        "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
        "${env:ProgramFiles}\Inno Setup 6\ISCC.exe"
    )

    $IsccExe = $null
    foreach ($path in $InnoDirs) {
        if (Test-Path $path) {
            $IsccExe = $path
            break
        }
    }

    if (-not $IsccExe) {
        $cmd = Get-Command iscc -ErrorAction SilentlyContinue
        if ($cmd) { $IsccExe = $cmd.Source }
    }

    if ($IsccExe) {
        Write-Host "[OK] Found Inno Setup at: $IsccExe" -ForegroundColor Green
        Write-Host "[*] Building Windows installer package..." -ForegroundColor Yellow
        $InnoProcess = Start-Process -FilePath $IsccExe -ArgumentList "`"$InstallerScript`"" -NoNewWindow -PassThru -Wait
        if ($InnoProcess.ExitCode -eq 0 -and (Test-Path $InstallerOutputFile)) {
            $SetupSize = (Get-Item $InstallerOutputFile).Length
            $SetupHash = (Get-FileHash $InstallerOutputFile -Algorithm SHA256).Hash
            Write-Host "[OK] Installer built successfully:" -ForegroundColor Green
            Write-Host "     Setup : $InstallerOutputFile" -ForegroundColor White
            Write-Host "     Size  : $([math]::Round($SetupSize / 1MB, 2)) MB" -ForegroundColor White
            Write-Host "     SHA256: $SetupHash" -ForegroundColor White
        } else {
            Write-Warning "Inno Setup compiler exited with code $($InnoProcess.ExitCode)."
        }
    } else {
        Write-Host "[i] Inno Setup (ISCC.exe) not found. Skipping installer package build." -ForegroundColor DarkGray
        Write-Host "    (Install via 'winget install JRSoftware.InnoSetup -e' to enable setup builds)" -ForegroundColor DarkGray
    }
}

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host "[OK] BUILD PIPELINE COMPLETE!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
