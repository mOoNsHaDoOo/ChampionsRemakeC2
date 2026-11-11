<#
  Scarica SDL2 da nuget.org (pacchetti sdl2.nuget e sdl2.nuget.redist) e la
  prepara per CMake in third_party/sdl2-nuget:

    third_party/sdl2-nuget/include/        header (SDL.h, ...)
    third_party/sdl2-nuget/lib/Win32|x64/  SDL2.lib
    third_party/sdl2-nuget/bin/Win32|x64/  SDL2.dll

  CMake (CMakeLists.txt) usa questa cartella da solo se esiste, per x86
  (Win32) e x64.  Non serve nuget.exe: i .nupkg sono archivi zip.

  Uso (da PowerShell, nella cartella src_c/readable):
    .\windows\get-sdl2-nuget.ps1
    .\windows\get-sdl2-nuget.ps1 -Version 2.30.10
  oppure doppio clic su windows\get-sdl2-nuget.cmd.

  Nota: sdl2.nuget e' un pacchetto della comunita' (kosmotema/sdl2-nuget)
  che ridistribuisce le librerie ufficiali di libsdl.org.
#>
param(
    [string]$Version = "2.30.10",
    [string]$Destination = (Join-Path $PSScriptRoot "..\third_party\sdl2-nuget")
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$work = Join-Path ([IO.Path]::GetTempPath()) ("cok-sdl2-" + [Guid]::NewGuid())
New-Item -ItemType Directory -Path $work | Out-Null

try {
    foreach ($id in @("sdl2.nuget", "sdl2.nuget.redist")) {
        $url = "https://api.nuget.org/v3-flatcontainer/$id/$Version/$id.$Version.nupkg"
        # Expand-Archive di Windows PowerShell 5.1 vuole l'estensione .zip.
        $zip = Join-Path $work "$id.zip"
        Write-Host "Scarico $url"
        Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
        Expand-Archive -Path $zip -DestinationPath (Join-Path $work $id) -Force
    }

    $dev = Join-Path $work "sdl2.nuget\build\native"
    $redist = Join-Path $work "sdl2.nuget.redist\build\native"

    if (Test-Path $Destination) {
        Remove-Item -Recurse -Force $Destination
    }
    New-Item -ItemType Directory -Path $Destination | Out-Null
    Copy-Item -Recurse (Join-Path $dev "include") (Join-Path $Destination "include")
    foreach ($arch in @("Win32", "x64")) {
        $lib = Join-Path $Destination "lib\$arch"
        $bin = Join-Path $Destination "bin\$arch"
        New-Item -ItemType Directory -Path $lib, $bin | Out-Null
        Copy-Item (Join-Path $dev "lib\$arch\SDL2.lib") $lib
        Copy-Item (Join-Path $redist "bin\$arch\SDL2.dll") $bin
    }
    Copy-Item (Join-Path $dev "docs\LICENSE.txt") $Destination
    Set-Content -Path (Join-Path $Destination "VERSION.txt") -Value $Version
    Write-Host "SDL2 $Version pronta in $((Resolve-Path $Destination).Path)"
}
finally {
    Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
}
