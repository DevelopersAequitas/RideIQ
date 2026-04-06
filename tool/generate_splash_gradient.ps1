# Regenerates assets/images/splash_native_gradient.png
# Same composite as AppColors: vertical + bottom-left royal blue + bottom-right cyan.

Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class SplashGradientFill {
  static void LerpVert(double ny, out int r, out int g, out int b) {
    double[] stops = { 0.0, 0.26, 0.5, 0.74, 0.88, 1.0 };
    int[,] cols = {
      { 0, 200, 150 }, { 0, 204, 160 }, { 0, 194, 181 },
      { 24, 180, 208 }, { 20, 168, 204 }
    };
    for (int i = 0; i < stops.Length - 1; i++) {
      if (ny <= stops[i + 1]) {
        double t = (ny - stops[i]) / (stops[i + 1] - stops[i]);
        if (t < 0) t = 0;
        if (t > 1) t = 1;
        int i0 = Math.Min(i, 4);
        int i1 = Math.Min(i + 1, 4);
        r = (int)Math.Round(cols[i0, 0] + (cols[i1, 0] - cols[i0, 0]) * t);
        g = (int)Math.Round(cols[i0, 1] + (cols[i1, 1] - cols[i0, 1]) * t);
        b = (int)Math.Round(cols[i0, 2] + (cols[i1, 2] - cols[i0, 2]) * t);
        return;
      }
    }
    r = cols[4, 0]; g = cols[4, 1]; b = cols[4, 2];
  }

  public static void Fill(IntPtr ptr, int w, int h, int stride) {
    double minSide = Math.Min(w, h);
    double rScale = minSide / 2.0;
    double cxB = (1.0 + (-0.92)) / 2.0 * w;
    double cyB = (1.0 + 0.96) / 2.0 * h;
    double rB = 1.14 * rScale;
    const double stopB = 0.62;
    int bBr = 30, bBg = 105, bBb = 222;
    double cxC = (1.0 + 0.92) / 2.0 * w;
    double cyC = (1.0 + 0.96) / 2.0 * h;
    double rC = 1.08 * rScale;
    const double stopC = 0.58;
    int cCr = 0, cCg = 168, cCb = 204;

    for (int y = 0; y < h; y++) {
      double ny = h <= 1 ? 0 : y / (double)(h - 1);
      int rowOff = y * stride;
      int r0, g0, b0;
      LerpVert(ny, out r0, out g0, out b0);
      for (int x = 0; x < w; x++) {
        int r = r0, g = g0, b = b0;
        double dB = Math.Sqrt((x - cxB) * (x - cxB) + (y - cyB) * (y - cyB));
        double tB = dB / rB;
        if (tB < stopB) {
          double u = tB / stopB;
          double aB = 1.0 - u;
          r = (int)Math.Round(bBr * aB + r * (1 - aB));
          g = (int)Math.Round(bBg * aB + g * (1 - aB));
          b = (int)Math.Round(bBb * aB + b * (1 - aB));
        }
        double dC = Math.Sqrt((x - cxC) * (x - cxC) + (y - cyC) * (y - cyC));
        double tC = dC / rC;
        if (tC < stopC) {
          double u = tC / stopC;
          double aC = 1.0 - u;
          r = (int)Math.Round(cCr * aC + r * (1 - aC));
          g = (int)Math.Round(cCg * aC + g * (1 - aC));
          b = (int)Math.Round(cCb * aC + b * (1 - aC));
        }
        int i = rowOff + x * 4;
        Marshal.WriteByte(ptr, i, (byte)Math.Max(0, Math.Min(255, b)));
        Marshal.WriteByte(ptr, i + 1, (byte)Math.Max(0, Math.Min(255, g)));
        Marshal.WriteByte(ptr, i + 2, (byte)Math.Max(0, Math.Min(255, r)));
        Marshal.WriteByte(ptr, i + 3, 255);
      }
    }
  }
}
"@ -Language CSharp

$w = 1080
$h = 1920
$bmp = New-Object System.Drawing.Bitmap $w, $h, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$rect = [System.Drawing.Rectangle]::new(0, 0, $w, $h)
$data = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::WriteOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
[SplashGradientFill]::Fill($data.Scan0, $w, $h, $data.Stride)
$bmp.UnlockBits($data)

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$out = Join-Path $root "assets\images\splash_native_gradient.png"
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Output "Wrote $out"
