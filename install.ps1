$GithubDir = "C:\backup\"
$fontFolderPath = "C:\backup\fonts"

# Get all .otf and .ttf files recursively from the folder
$fontFiles = Get-ChildItem -Path $fontFolderPath -Recurse -Include *.otf, *.ttf

# Define a function to install a font
function Install-Font {
    param (
        [string]$filePath
    )

    # Copy font to system fonts folder
    $fontDestination = "$env:SystemRoot\Fonts\$(Split-Path -Leaf $filePath)"
    Copy-Item -Path $filePath -Destination $fontDestination -Force

    # Register the font in the system registry
    $fontName = (New-Object -ComObject Shell.Application).Namespace((Split-Path -Parent $filePath)).ParseName((Split-Path -Leaf $filePath)).ExtendedProperty("System.ItemNameDisplay")
    $keyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    New-ItemProperty -Path $keyPath -Name $fontName -PropertyType String -Value (Split-Path -Leaf $filePath) -Force
}

# Loop through each font file and install it
foreach ($font in $fontFiles) {
    Write-Output "Installing font: $($font.FullName)"
    Install-Font -filePath $font.FullName
}

Write-Output "All fonts have been installed."
