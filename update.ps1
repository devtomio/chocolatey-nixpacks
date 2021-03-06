Import-Module AU

$releases = 'https://github.com/railwayapp/nixpacks/releases'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*FileFullPath\s*=\s*)(.*)" = "`$1Join-Path `$toolsDir '$($Latest.FileName32)'"
            "(?i)(^\s*FileFullPath64\s*=\s*)(.*)" = "`$1Join-Path `$toolsDir '$($Latest.FileName64)'"
        }
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
            "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
            "(?i)(\s+x64:).*"            = "`${1} $($Latest.URL64)"
            "(?i)(checksum64:).*"        = "`${1} $($Latest.Checksum64)"
        }
    }
}

function global:au_BeforeUpdate {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $url_base = 'https://github.com'
    $urls =  $download_page.Links | Where-Object href -match 'pc-windows-msvc' | ForEach-Object href | Select-Object -First 2
    $url32 = $url_base + $urls.Where({ $_ -match 686 }) 
    $url64 = $url_base + $urls.Where({ $_ -match 64 })
    
    @{
        URL32 = $url32
        URL64 = $url64
        Version = "0.1.1"
    }
}

Update-Package -ChecksumFor None