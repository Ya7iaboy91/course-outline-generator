# Builds the self-contained course-outline-generator.html
# Inlines pdfmake + fonts + base64 images into a single HTML file.

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
$src  = Join-Path $root "src\app.html"
$out  = Join-Path $root "course-outline-generator.html"
$index = Join-Path $root "index.html"

$pdf  = Get-Content -LiteralPath (Join-Path $root "lib\pdfmake.min.js") -Raw
$vfs  = Get-Content -LiteralPath (Join-Path $root "lib\vfs_fonts.js") -Raw

$logoB64 = [Convert]::ToBase64String(
    [IO.File]::ReadAllBytes((Resolve-Path -LiteralPath (Join-Path $root "assets\logo.jpg")).Path)
)
$coverB64 = [Convert]::ToBase64String(
    [IO.File]::ReadAllBytes((Resolve-Path -LiteralPath (Join-Path $root "assets\cover_small.jpg")).Path)
)

$html = Get-Content -LiteralPath $src -Raw
$html = $html.Replace("__PDFMAKE_JS__", $pdf)
$html = $html.Replace("__VFS_JS__", $vfs)
$html = $html.Replace("__LOGO_B64__", $logoB64)
$html = $html.Replace("__COVER_B64__", $coverB64)

$html = $html.Replace("`r`n", "`n")

[IO.File]::WriteAllText($out, $html, (New-Object System.Text.UTF8Encoding($false)))
[IO.File]::WriteAllText($index, $html, (New-Object System.Text.UTF8Encoding($false)))

$size = (Get-Item -LiteralPath $out).Length
Write-Host "Built $out ($size bytes)"
Write-Host "Built $index (same content, served directly at the site root)"