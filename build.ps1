[CmdletBinding()]
param (
    [switch]$NoInstaller,
    [switch]$NoZip
)

$ErrorActionPreference = 'Stop'
$ScriptDir = $PSScriptRoot
$SourceFile = Join-Path $ScriptDir "IDM Backup Manager.au3"
$IconFile = Join-Path $ScriptDir "Resources\icon.ico"
$OutputDir = Join-Path $ScriptDir "bin"
$DistDir = Join-Path $ScriptDir "dist"
$OutputFileX86 = Join-Path $OutputDir "IDM Backup Manager.exe"
$OutputFileX64 = Join-Path $OutputDir "IDM Backup Manager_x64.exe"
$InstallerScript = Join-Path $ScriptDir "Build\installer.iss"
$SetupOutputX86 = Join-Path $OutputDir "IDM_Backup_Manager_v1.1.0_x86_Setup.exe"
$SetupOutputX64 = Join-Path $OutputDir "IDM_Backup_Manager_v1.1.0_x64_Setup.exe"
$ZipOutputX86 = Join-Path $OutputDir "IDM_Backup_Manager_v1.1.0_x86.zip"
$ZipOutputX64 = Join-Path $OutputDir "IDM_Backup_Manager_v1.1.0_x64.zip"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "    IDM Backup Manager - Unified 4-Package Build Pipeline" -ForegroundColor Cyan
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

$CheckProcess = Start-Process -FilePath $Au3Check -ArgumentList "-I `"$IncludesDir`" `"$SourceFile`" -q" -NoNewWindow -PassThru -Wait
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
    Write-Host "[*] Extracting 7-zip32.dll from release package..." -ForegroundColor Yellow
    try {
        $tempZip = Join-Path $env:TEMP "idmbm_x86_temp.zip"
        Invoke-WebRequest -Uri "$ReleaseBase/IDM_Backup_Manager_v1.1.0_x86.zip" -OutFile $tempZip -UseBasicParsing
        $tempExtract = Join-Path $env:TEMP "idmbm_x86_extract"
        Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force
        Copy-Item (Join-Path $tempExtract "7-zip32.dll") -Destination $Dll32 -Force
        Remove-Item $tempZip, $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "[OK] Extracted 7-zip32.dll" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to acquire 7-zip32.dll: $_"
    }
}
if (-not (Test-Path $Dll64)) {
    Write-Host "[*] Extracting 7-zip64.dll from release package..." -ForegroundColor Yellow
    try {
        $tempZip = Join-Path $env:TEMP "idmbm_x64_temp.zip"
        Invoke-WebRequest -Uri "$ReleaseBase/IDM_Backup_Manager_v1.1.0_x64.zip" -OutFile $tempZip -UseBasicParsing
        $tempExtract = Join-Path $env:TEMP "idmbm_x64_extract"
        Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force
        Copy-Item (Join-Path $tempExtract "7-zip64.dll") -Destination $Dll64 -Force
        Remove-Item $tempZip, $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "[OK] Extracted 7-zip64.dll" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to acquire 7-zip64.dll: $_"
    }
}

# 4. Compile Application (Both x86 and x64)
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

# Clear previous binaries
Remove-Item $OutputFileX86 -Force -ErrorAction SilentlyContinue
Remove-Item $OutputFileX64 -Force -ErrorAction SilentlyContinue

if ($WrapperPath) {
    Write-Host "[*] Compiling x86 and x64 with AutoIt3Wrapper..." -ForegroundColor Yellow
    $AutoItExe = Join-Path $AutoItRoot "AutoIt3.exe"
    if ($WrapperPath.EndsWith(".au3")) {
        $CompileProcess = Start-Process -FilePath $AutoItExe -ArgumentList "`"$WrapperPath`" /in `"$SourceFile`"" -NoNewWindow -PassThru -Wait
    } else {
        $CompileProcess = Start-Process -FilePath $WrapperPath -ArgumentList "/in `"$SourceFile`"" -NoNewWindow -PassThru -Wait
    }
} else {
    Write-Host "[*] Compiling x86 binary with Aut2exe..." -ForegroundColor Yellow
    Start-Process -FilePath $Aut2exe -ArgumentList "/in `"$SourceFile`" /out `"$OutputFileX86`" /icon `"$IconFile`" /x86 /comp 4" -NoNewWindow -PassThru -Wait
    Write-Host "[*] Compiling x64 binary with Aut2exe..." -ForegroundColor Yellow
    Start-Process -FilePath $Aut2exe -ArgumentList "/in `"$SourceFile`" /out `"$OutputFileX64`" /icon `"$IconFile`" /x64 /comp 4" -NoNewWindow -PassThru -Wait
}

if (-not (Test-Path $OutputFileX86) -or -not (Test-Path $OutputFileX64)) {
    Write-Error "Compilation failed! Missing output executables."
    exit 1
}

# Copy documentation & assets to bin
Copy-Item -Path (Join-Path $ScriptDir "Resources") -Destination $OutputDir -Recurse -Force
Copy-Item -Path (Join-Path $ScriptDir "History.txt") -Destination $OutputDir -Force
Copy-Item -Path (Join-Path $ScriptDir "CmdLine.txt") -Destination $OutputDir -Force
Copy-Item -Path (Join-Path $ScriptDir "LICENSE") -Destination $OutputDir -Force
Copy-Item -Path (Join-Path $ScriptDir "LICENSE-7ZIP.txt") -Destination $OutputDir -Force

Write-Host "[OK] x86 Binary compiled: $OutputFileX86 ($([math]::Round((Get-Item $OutputFileX86).Length / 1KB, 1)) KB)" -ForegroundColor Green
Write-Host "[OK] x64 Binary compiled: $OutputFileX64 ($([math]::Round((Get-Item $OutputFileX64).Length / 1KB, 1)) KB)" -ForegroundColor Green

# 5. Build Windows Setup Installers (x86 and x64) with Inno Setup
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

        # Build x86 Setup
        Write-Host "[*] Building x86 Windows installer..." -ForegroundColor Yellow
        Start-Process -FilePath $IsccExe -ArgumentList "/DAppArch=x86 `"$InstallerScript`"" -NoNewWindow -PassThru -Wait
        if (Test-Path $SetupOutputX86) {
            Write-Host "[OK] Built: $SetupOutputX86 ($([math]::Round((Get-Item $SetupOutputX86).Length / 1MB, 2)) MB)" -ForegroundColor Green
        }

        # Build x64 Setup
        Write-Host "[*] Building x64 Windows installer..." -ForegroundColor Yellow
        Start-Process -FilePath $IsccExe -ArgumentList "/DAppArch=x64 `"$InstallerScript`"" -NoNewWindow -PassThru -Wait
        if (Test-Path $SetupOutputX64) {
            Write-Host "[OK] Built: $SetupOutputX64 ($([math]::Round((Get-Item $SetupOutputX64).Length / 1MB, 2)) MB)" -ForegroundColor Green
        }
    } else {
        Write-Warning "Inno Setup (ISCC.exe) not found. Skipping installer package build."
    }
}

# 6. Package Standalone ZIP Releases (x86 and x64)
if (-not $NoZip) {
    Write-Host "`n[*] Packaging Standalone Portable ZIP Releases..." -ForegroundColor Yellow

    # Staging x86
    $StageX86 = Join-Path $DistDir "x86"
    if (Test-Path $StageX86) { Remove-Item $StageX86 -Recurse -Force }
    New-Item -ItemType Directory -Path $StageX86 | Out-Null

    Copy-Item -Path $OutputFileX86 -Destination (Join-Path $StageX86 "IDM Backup Manager.exe") -Force
    Copy-Item -Path $Dll32 -Destination (Join-Path $StageX86 "7-zip32.dll") -Force
    Copy-Item -Path (Join-Path $ScriptDir "LICENSE") -Destination $StageX86 -Force
    Copy-Item -Path (Join-Path $ScriptDir "LICENSE-7ZIP.txt") -Destination $StageX86 -Force
    Copy-Item -Path (Join-Path $ScriptDir "History.txt") -Destination $StageX86 -Force
    Copy-Item -Path (Join-Path $ScriptDir "CmdLine.txt") -Destination $StageX86 -Force
    Copy-Item -Path (Join-Path $ScriptDir "Help") -Destination $StageX86 -Recurse -Force
    Copy-Item -Path (Join-Path $ScriptDir "Resources") -Destination $StageX86 -Recurse -Force

    Remove-Item $ZipOutputX86 -Force -ErrorAction SilentlyContinue
    Compress-Archive -Path "$StageX86\*" -DestinationPath $ZipOutputX86 -Force
    Write-Host "[OK] Built Portable ZIP (x86): $ZipOutputX86 ($([math]::Round((Get-Item $ZipOutputX86).Length / 1MB, 2)) MB)" -ForegroundColor Green

    # Staging x64
    $StageX64 = Join-Path $DistDir "x64"
    if (Test-Path $StageX64) { Remove-Item $StageX64 -Recurse -Force }
    New-Item -ItemType Directory -Path $StageX64 | Out-Null

    Copy-Item -Path $OutputFileX64 -Destination (Join-Path $StageX64 "IDM Backup Manager.exe") -Force
    Copy-Item -Path $Dll64 -Destination (Join-Path $StageX64 "7-zip64.dll") -Force
    Copy-Item -Path (Join-Path $ScriptDir "LICENSE") -Destination $StageX64 -Force
    Copy-Item -Path (Join-Path $ScriptDir "LICENSE-7ZIP.txt") -Destination $StageX64 -Force
    Copy-Item -Path (Join-Path $ScriptDir "History.txt") -Destination $StageX64 -Force
    Copy-Item -Path (Join-Path $ScriptDir "CmdLine.txt") -Destination $StageX64 -Force
    Copy-Item -Path (Join-Path $ScriptDir "Help") -Destination $StageX64 -Recurse -Force
    Copy-Item -Path (Join-Path $ScriptDir "Resources") -Destination $StageX64 -Recurse -Force

    Remove-Item $ZipOutputX64 -Force -ErrorAction SilentlyContinue
    Compress-Archive -Path "$StageX64\*" -DestinationPath $ZipOutputX64 -Force
    # Clean up staging directory
    if (Test-Path $DistDir) {
        Remove-Item $DistDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 7. Release Summary
Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host "                RELEASE ARTIFACTS SUMMARY" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green

$Artifacts = @(
    $ZipOutputX86,
    $ZipOutputX64,
    $SetupOutputX86,
    $SetupOutputX64
)

foreach ($art in $Artifacts) {
    if (Test-Path $art) {
        $item = Get-Item $art
        $hash = (Get-FileHash $art -Algorithm SHA256).Hash
        $sizeMB = [math]::Round($item.Length / 1MB, 2)
        Write-Host "File  : $($item.Name)" -ForegroundColor White
        Write-Host "Size  : $sizeMB MB" -ForegroundColor DarkGray
        Write-Host "SHA256: $hash" -ForegroundColor DarkGray
        Write-Host "----------------------------------------------------------" -ForegroundColor DarkGray
    }
}
Write-Host "[OK] ALL 4 PACKAGES BUILT SUCCESSFULLY!" -ForegroundColor Green
