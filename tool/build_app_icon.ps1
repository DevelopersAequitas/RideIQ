# Builds assets/images/app_icon.png (1024x1024, white background).
# Uses the FULL RideIQ_App_Icon.png (no height crop) so no content is cut.
# Trims near-white/transparent margins tightly, then centres the logo on the
# canvas with explicit horizontal AND vertical padding so no artwork is clipped
# by rounded-corner masks on Android or iOS.
#
# Run: powershell -File tool/build_app_icon.ps1

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

function Get-ContentBounds {
  param(
    [System.Drawing.Bitmap]$Source,
    [int]$WhiteThreshold = 240
  )
  $w = $Source.Width
  $h = $Source.Height
  $minX = $w
  $minY = $h
  $maxX = 0
  $maxY = 0
  $found = $false
  for ($yy = 0; $yy -lt $h; $yy++) {
    for ($xx = 0; $xx -lt $w; $xx++) {
      $c = $Source.GetPixel($xx, $yy)
      # Skip fully transparent pixels
      if ($c.A -lt 10) { continue }
      # Skip near-white opaque pixels (background)
      if ($c.R -ge $WhiteThreshold -and $c.G -ge $WhiteThreshold -and $c.B -ge $WhiteThreshold -and $c.A -ge 245) { continue }
      $found = $true
      if ($xx -lt $minX) { $minX = $xx }
      if ($yy -lt $minY) { $minY = $yy }
      if ($xx -gt $maxX) { $maxX = $xx }
      if ($yy -gt $maxY) { $maxY = $yy }
    }
  }
  if (-not $found) { return $null }
  return [PSCustomObject]@{ MinX=$minX; MinY=$minY; MaxX=$maxX; MaxY=$maxY }
}

$root      = Resolve-Path (Join-Path $PSScriptRoot "..")
$logoPath  = Join-Path $root "assets\images\RideIQ_App_Icon.png"
$outPath   = Join-Path $root "assets\images\app_icon.png"

# Maximum logo width / height as a fraction of the 1024 canvas.
# The logo is ~3.5:1 wide, so width is always the binding constraint.
# Reduce $maxWidthFraction to add more horizontal padding on both sides.
$maxWidthFraction  = 0.60   # logo may use at most 60% of canvas width
$maxHeightFraction = 0.70   # logo may use at most 70% of canvas height

if (-not (Test-Path -LiteralPath $logoPath)) {
  throw "Logo not found: $logoPath"
}

$size         = 1024
$maxLogoW     = [double]$size * $maxWidthFraction
$maxLogoH     = [double]$size * $maxHeightFraction

$logo = [System.Drawing.Bitmap][System.Drawing.Image]::FromFile($logoPath)
try {
  # --- Step 1: find the tight bounding box of actual content ---
  $bounds = Get-ContentBounds -Source $logo -WhiteThreshold 240
  if ($null -eq $bounds) {
    Write-Warning "No non-white content found; using full image."
    $bounds = [PSCustomObject]@{ MinX=0; MinY=0; MaxX=($logo.Width-1); MaxY=($logo.Height-1) }
  }

  $cw = $bounds.MaxX - $bounds.MinX + 1
  $ch = $bounds.MaxY - $bounds.MinY + 1

  Write-Output "Content bounds: ($($bounds.MinX),$($bounds.MinY)) -> ($($bounds.MaxX),$($bounds.MaxY))  size: ${cw}x${ch}"

  # --- Step 2: scale to fit inside max-width AND max-height box, keeping aspect ratio ---
  $scale = [math]::Min($maxLogoW / $cw, $maxLogoH / $ch)
  $nw    = [int][math]::Round($cw * $scale)
  $nh    = [int][math]::Round($ch * $scale)
  if ($nw -lt 1) { $nw = 1 }
  if ($nh -lt 1) { $nh = 1 }

  # --- Step 3: centre on white 1024x1024 canvas ---
  $x = [int][math]::Round(($size - $nw) / 2.0)
  $y = [int][math]::Round(($size - $nh) / 2.0)

  Write-Output "Placing logo at ($x,$y) scaled to ${nw}x${nh} on ${size}x${size} canvas"

  $canvas = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($canvas)
  $g.Clear([System.Drawing.Color]::White)
  $g.InterpolationMode    = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode      = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.SmoothingMode        = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.CompositingQuality   = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

  $srcRect = New-Object System.Drawing.Rectangle $bounds.MinX, $bounds.MinY, $cw, $ch
  $dstRect = New-Object System.Drawing.Rectangle $x, $y, $nw, $nh
  $g.DrawImage($logo, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
  $g.Dispose()

  $canvas.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
  $canvas.Dispose()
  Write-Output "Wrote $outPath  (full logo, centred, max W=$([int]($maxWidthFraction*100))% H=$([int]($maxHeightFraction*100))%)"
}
finally {
  $logo.Dispose()
}
