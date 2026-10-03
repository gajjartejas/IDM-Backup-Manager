[CmdletBinding()]
param (
    [ValidateSet('x86', 'x64')]
    [string]$Arch = 'x86'
)

$ErrorActionPreference = 'Stop'
$ScriptDir = $PSScriptRoot
$SourceFile = Join-Path $ScriptDir "IDM Backup Manager.au3"
$IconFile = Join-Path $ScriptDir "Resources\icon.ico"
$OutputDir = Join-Path $ScriptDir "bin"
$OutputFile = Join-Path $OutputDir "IDM Backup Manager.exe"

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

# 3. Create Output Directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# 4. Compile with Aut2exe
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
if ($CompileProcess.ExitCode -ne 0 -or -not (Test-Path $OutputFile)) {
    Write-Error "Compilation failed!"
    exit 1
}

$FileSize = (Get-Item $OutputFile).Length
$FileHash = (Get-FileHash $OutputFile -Algorithm SHA256).Hash

Write-Host "==========================================================" -ForegroundColor Green
Write-Host "[OK] BUILD SUCCESSFUL!" -ForegroundColor Green
Write-Host "    Output: $OutputFile" -ForegroundColor White
Write-Host "    Size  : $([math]::Round($FileSize / 1KB, 2)) KB" -ForegroundColor White
Write-Host "    SHA256: $FileHash" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Green
