# Tạo shortcut "ThoiGianBieu" trên Desktop, mở app trong cửa sổ riêng (không hiện thanh địa chỉ).
# Chạy: chuột phải file này -> Run with PowerShell, hoặc mở PowerShell rồi chạy: .\cai_dat.ps1

$ErrorActionPreference = "Stop"

$appDir = $PSScriptRoot
$html = Join-Path $appDir "index.html"
if (-not (Test-Path $html)) { throw "Không tìm thấy index.html cạnh script này." }

# Tìm trình duyệt đã cài (Edge có sẵn trên Windows 11)
$candidates = @(
    (Join-Path ${env:ProgramFiles(x86)} "Microsoft\Edge\Application\msedge.exe"),
    (Join-Path $env:ProgramFiles "Microsoft\Edge\Application\msedge.exe"),
    (Join-Path $env:ProgramFiles "Google\Chrome\Application\chrome.exe"),
    (Join-Path $env:LOCALAPPDATA "Google\Chrome\Application\chrome.exe")
)
$browser = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) { throw "Không tìm thấy Edge hoặc Chrome trên máy này." }

$uri = ([System.Uri]::new($html)).AbsoluteUri
$desktop = [Environment]::GetFolderPath("Desktop")
$lnkPath = Join-Path $desktop "ThoiGianBieu.lnk"

$shell = New-Object -ComObject WScript.Shell
$lnk = $shell.CreateShortcut($lnkPath)
$lnk.TargetPath = $browser
$lnk.Arguments = "--app=`"$uri`""
$lnk.WorkingDirectory = $appDir
$lnk.IconLocation = "$browser,0"
$lnk.Description = "Thời gian biểu của tôi"
$lnk.Save()

Write-Host "Đã tạo shortcut trên Desktop: $lnkPath"
Write-Host "Nhấp đúp shortcut ThoiGianBieu để mở app."
