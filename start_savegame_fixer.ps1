# start_savegame_fixer.ps1
# PowerShell 5.1 compatible

Write-Host "Checking for Python installation..." -ForegroundColor Cyan

$pythonCmd = $null
$pythonPath = $null
$pythonVersion = $null

# Check python command
try {
    $cmd = Get-Command python -ErrorAction Stop
    $pythonCmd = "python"
    $pythonPath = $cmd.Source
    $pythonVersion = & python --version 2>&1
}
catch {}

# Check py launcher
if (-not $pythonPath) {
    try {
        $cmd = Get-Command py -ErrorAction Stop
        $pythonCmd = "py"
        $pythonPath = $cmd.Source
        $pythonVersion = & py --version 2>&1
    }
    catch {}
}

if ($pythonPath) {
    Write-Host ""
    Write-Host "Python found!" -ForegroundColor Green
    Write-Host "Version: $pythonVersion"
    Write-Host "Path: $pythonPath"
}
else {
    Write-Host ""
    Write-Host "Python is NOT installed or not in PATH." -ForegroundColor Red
    Write-Host ""
    Pause
    exit 1
}

Write-Host ""

# Paths
$scriptDir       = Split-Path -Parent $MyInvocation.MyCommand.Path
$tempDir         = Join-Path $scriptDir "temp"
$zipUrl          = "https://github.com/VincentHenauGithub/ark-save-parser/archive/refs/heads/main.zip"
$zipFile         = Join-Path $tempDir "ark-save-parser-main.zip"
$extractDir      = $tempDir
$parserDir       = Join-Path $tempDir "ark-save-parser-main"
$savegameDir     = Join-Path $scriptDir "YOUR_SAVEGAME_HERE"
$savegameFile    = Join-Path $savegameDir "LostColony_WP.ark"
$localFixScript  = Join-Path $scriptDir "src\fix_lc_city_npcs.py"
$targetFixScript = Join-Path $parserDir "fix_lc_city_npcs.py"

Write-Host "Preparing temp directory..." -ForegroundColor Cyan

if (-not (Test-Path $tempDir)) {
    try {
        New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
    }
    catch {
        Write-Host ""
        Write-Host "Failed to create temp directory: $tempDir" -ForegroundColor Red
        Write-Host $_.Exception.Message
        Write-Host ""
        Pause
        exit 1
    }
}

Write-Host "Temp directory ready: $tempDir" -ForegroundColor Green

Write-Host ""
Write-Host "Checking ark-save-parser archive..." -ForegroundColor Cyan

if (-not (Test-Path $zipFile)) {
    Write-Host "Archive not found. Downloading latest ark-save-parser from GitHub..." -ForegroundColor Yellow

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -UseBasicParsing
    }
    catch {
        Write-Host ""
        Write-Host "Failed to download ark-save-parser." -ForegroundColor Red
        Write-Host $_.Exception.Message
        Write-Host ""
        Pause
        exit 1
    }

    if (-not (Test-Path $zipFile)) {
        Write-Host ""
        Write-Host "Download failed: ZIP file was not created." -ForegroundColor Red
        Write-Host ""
        Pause
        exit 1
    }

    Write-Host "Download completed: $zipFile" -ForegroundColor Green
}
else {
    Write-Host "Archive already exists. Skipping download: $zipFile" -ForegroundColor Green
}

Write-Host ""
Write-Host "Preparing fresh parser directory..." -ForegroundColor Cyan

if (Test-Path $parserDir) {
    try {
        Remove-Item $parserDir -Recurse -Force
    }
    catch {
        Write-Host ""
        Write-Host "Failed to remove existing parser directory: $parserDir" -ForegroundColor Red
        Write-Host $_.Exception.Message
        Write-Host ""
        Pause
        exit 1
    }
}

Write-Host ""
Write-Host "Extracting archive..." -ForegroundColor Cyan

try {
    Expand-Archive -Path $zipFile -DestinationPath $extractDir -Force
}
catch {
    Write-Host ""
    Write-Host "Failed to extract archive." -ForegroundColor Red
    Write-Host $_.Exception.Message
    Write-Host ""
    Pause
    exit 1
}

if (-not (Test-Path $parserDir)) {
    Write-Host ""
    Write-Host "Extracted parser directory not found: $parserDir" -ForegroundColor Red
    Write-Host ""
    Pause
    exit 1
}

Write-Host "Parser extracted successfully: $parserDir" -ForegroundColor Green

Write-Host ""
Write-Host "Checking local fix script..." -ForegroundColor Cyan

if (-not (Test-Path $localFixScript)) {
    Write-Host ""
    Write-Host "Local fix script not found: $localFixScript" -ForegroundColor Red
    Write-Host "Make sure your custom script exists in src\\fix_lc_city_npcs.py"
    Write-Host ""
    Pause
    exit 1
}

Write-Host "Local fix script found: $localFixScript" -ForegroundColor Green

Write-Host ""
Write-Host "Copying fix script into temp ark-save-parser-main..." -ForegroundColor Cyan

try {
    Copy-Item -Path $localFixScript -Destination $targetFixScript -Force
}
catch {
    Write-Host ""
    Write-Host "Failed to copy fix script into parser directory." -ForegroundColor Red
    Write-Host $_.Exception.Message
    Write-Host ""
    Pause
    exit 1
}

if (-not (Test-Path $targetFixScript)) {
    Write-Host ""
    Write-Host "Copied fix script not found: $targetFixScript" -ForegroundColor Red
    Write-Host ""
    Pause
    exit 1
}

Write-Host "Fix script copied successfully." -ForegroundColor Green

Set-Location $parserDir

Write-Host ""
Write-Host "Checking for pip..." -ForegroundColor Cyan

$pipAvailable = $false

try {
    & $pythonCmd -m pip --version *> $null
    if ($LASTEXITCODE -eq 0) {
        $pipAvailable = $true
    }
}
catch {}

if (-not $pipAvailable) {
    Write-Host "pip not found. Installing pip with ensurepip..." -ForegroundColor Yellow

    try {
        & $pythonCmd -m ensurepip --upgrade
        if ($LASTEXITCODE -ne 0) {
            throw "ensurepip failed"
        }
    }
    catch {
        Write-Host ""
        Write-Host "Failed to install pip automatically." -ForegroundColor Red
        Write-Host "Please install pip manually and run this script again."
        Write-Host ""
        Pause
        exit 1
    }

    try {
        & $pythonCmd -m pip --version *> $null
        if ($LASTEXITCODE -eq 0) {
            $pipAvailable = $true
        }
    }
    catch {}
}

if ($pipAvailable) {
    Write-Host "pip is available." -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "pip is still not available after ensurepip." -ForegroundColor Red
    Write-Host ""
    Pause
    exit 1
}

Write-Host ""
Write-Host "Running: pip install -e ." -ForegroundColor Cyan

try {
    & $pythonCmd -m pip install -e .
    if ($LASTEXITCODE -ne 0) {
        throw "pip install -e . failed"
    }
}
catch {
    Write-Host ""
    Write-Host "Installation failed." -ForegroundColor Red
    Write-Host $_.Exception.Message
    Write-Host ""
    Pause
    exit 1
}

Write-Host ""
Write-Host "Editable install completed successfully." -ForegroundColor Green

Set-Location $scriptDir

Write-Host ""
Write-Host "Checking savegame directory..." -ForegroundColor Cyan

if (-not (Test-Path $savegameDir)) {
    Write-Host ""
    Write-Host "Directory not found: $savegameDir" -ForegroundColor Red
    Write-Host "Please create the folder 'YOUR_SAVEGAME_HERE' in the same directory as this script."
    Write-Host ""
    Pause
    exit 1
}

Write-Host "Savegame directory found: $savegameDir" -ForegroundColor Green

Write-Host ""
Write-Host "Checking required savegame file..." -ForegroundColor Cyan

if (-not (Test-Path $savegameFile)) {
    Write-Host ""
    Write-Host "Required file not found: $savegameFile" -ForegroundColor Red
    Write-Host "Please place your LostColony_WP.ark file inside the 'YOUR_SAVEGAME_HERE' folder."
    Write-Host ""
    Pause
    exit 1
}

Write-Host "Savegame file found: $savegameFile" -ForegroundColor Green

Write-Host ""
Write-Host "Checking fix script..." -ForegroundColor Cyan

if (-not (Test-Path $targetFixScript)) {
    Write-Host ""
    Write-Host "Fix script not found: $targetFixScript" -ForegroundColor Red
    Write-Host ""
    Pause
    exit 1
}

Write-Host "Fix script found: $targetFixScript" -ForegroundColor Green

Write-Host ""
Write-Host "Starting fix_lc_city_npcs.py..." -ForegroundColor Cyan

try {
    & $pythonCmd $targetFixScript
    if ($LASTEXITCODE -ne 0) {
        throw "fix_lc_city_npcs.py failed"
    }
}
catch {
    Write-Host ""
    Write-Host "The fix script failed." -ForegroundColor Red
    Write-Host $_.Exception.Message
    Write-Host ""
    Pause
    exit 1
}

Write-Host ""
Write-Host "Done. The fix script finished successfully." -ForegroundColor Green
Write-Host ""
Pause