# Generates Android mipmap + drawable foreground PNGs and iOS AppIcon PNGs
# from assets/images/app_icon.png (run after build_app_icon.ps1).
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

function Save-ResizedPng {
  param(
    [string]$SourcePath,
    [string]$DestPath,
    [int]$Size
  )
  $dir = Split-Path -Parent $DestPath
  if (-not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
  }
  $src = [System.Drawing.Image]::FromFile($SourcePath)
  try {
    $bmp = New-Object System.Drawing.Bitmap $Size, $Size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)
    $g.DrawImage($src, 0, 0, $Size, $Size)
    $g.Dispose()
    $bmp.Save($DestPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
  }
  finally {
    $src.Dispose()
  }
}

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$srcIcon = Join-Path $root "assets\images\app_icon.png"
if (-not (Test-Path -LiteralPath $srcIcon)) {
  throw "Missing $srcIcon. Run tool\build_app_icon.ps1 first."
}

$res = Join-Path $root "android\app\src\main\res"

# Legacy launcher (pre-adaptive fallback)
$legacy = @{
  "mipmap-mdpi"    = 48
  "mipmap-hdpi"    = 72
  "mipmap-xhdpi"   = 96
  "mipmap-xxhdpi"  = 144
  "mipmap-xxxhdpi" = 192
}
foreach ($folder in $legacy.Keys) {
  $out = Join-Path $res "$folder\ic_launcher.png"
  Save-ResizedPng -SourcePath $srcIcon -DestPath $out -Size $legacy[$folder]
  Write-Output "Wrote $out"
}

# Adaptive foreground layers
$foreground = @{
  "drawable-mdpi"    = 108
  "drawable-hdpi"    = 162
  "drawable-xhdpi"   = 216
  "drawable-xxhdpi"  = 324
  "drawable-xxxhdpi" = 432
}
foreach ($folder in $foreground.Keys) {
  $out = Join-Path $res "$folder\ic_launcher_foreground.png"
  Save-ResizedPng -SourcePath $srcIcon -DestPath $out -Size $foreground[$folder]
  Write-Output "Wrote $out"
}

# iOS AppIcon (unique filenames from Contents.json)
$iosDir = Join-Path $root "ios\Runner\Assets.xcassets\AppIcon.appiconset"
$iosSizes = @{
  "Icon-App-20x20@2x.png"       = 40
  "Icon-App-20x20@3x.png"       = 60
  "Icon-App-29x29@1x.png"       = 29
  "Icon-App-29x29@2x.png"       = 58
  "Icon-App-29x29@3x.png"       = 87
  "Icon-App-40x40@2x.png"       = 80
  "Icon-App-40x40@3x.png"       = 120
  "Icon-App-60x60@2x.png"       = 120
  "Icon-App-60x60@3x.png"       = 180
  "Icon-App-20x20@1x.png"       = 20
  "Icon-App-40x40@1x.png"       = 40
  "Icon-App-76x76@1x.png"       = 76
  "Icon-App-76x76@2x.png"       = 152
  "Icon-App-83.5x83.5@2x.png"   = 167
  "Icon-App-1024x1024@1x.png"   = 1024
}
foreach ($name in $iosSizes.Keys) {
  $out = Join-Path $iosDir $name
  Save-ResizedPng -SourcePath $srcIcon -DestPath $out -Size $iosSizes[$name]
  Write-Output "Wrote $out"
}

Write-Output "Done."
