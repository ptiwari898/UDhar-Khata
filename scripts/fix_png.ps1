Add-Type -AssemblyName System.Drawing
$logoPath = "E:\ne w project bhai\UDhar-Khata\flutter_app\assets\images\logo.png"
$bmp = [System.Drawing.Image]::FromFile($logoPath)

$resDir = "E:\ne w project bhai\UDhar-Khata\flutter_app\android\app\src\main\res"
$mipmaps = @('mipmap-mdpi', 'mipmap-hdpi', 'mipmap-xhdpi', 'mipmap-xxhdpi', 'mipmap-xxxhdpi')

foreach ($m in $mipmaps) {
    $outPath = Join-Path $resDir (Join-Path $m "ic_launcher.png")
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "Converted and saved valid PNG to $outPath"
}

$bmp.Dispose()
Write-Host "PNG signatures fixed successfully across all mipmaps!"
