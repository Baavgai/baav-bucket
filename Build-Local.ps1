$ScoopCmd = (get-command scoop).Source

function Get-Manifest {
    param($AppName)
    $fh = New-TemporaryFile
    # $json = & $ScoopCmd cat $AppName 6>> "foo.json"
    & $ScoopCmd cat $AppName 6>> $fh
    Get-Content $fh | ConvertFrom-Json
    Remove-Item $fh | Out-Null
}

function Get-ManifestForLocal {
    param(
        [string]$AppName,
        [string]$LocalCache = "./cache"
    )
    
    Get-Manifest $AppName |
    ForEach-Object {
        $cache = @()
        [PSCustomObject]$x = $_
        $x.psobject.properties.remove('checkver')
        $x.psobject.properties.remove('autoupdate')
        $x.architecture.psobject.properties.name |
        ForEach-Object {
            $name = $_
            $url = $x.architecture.$name.url | ForEach-Object {
                $cache += $_
                Join-Path $LocalCache $AppName $(Split-Path -Leaf $_)
            }
            $x.architecture.$name = [PSCustomObject]@{ url = $url }
            # Write-Host $x.architecture.$name.url.Length
        }
        $json = $x | ConvertTo-Json -Depth 100
        [PSCustomObject]@{ 
            AppName = $AppName
            Cache = $cache | Sort-Object | Get-Unique
            JSON = $json
         }
        
    }
    
}

function Build-Cache {
    param(
        [string]$AppName,
        [string]$LocalBucket = "./bucket",
        [string]$LocalCache = "./cache"
    )
    $cacheStub = Join-Path $LocalCache $AppName
    if (!(Test-Path $cacheStub)) {
        New-Item -Path $cacheStub -ItemType Director | Out-Null
    }
    Get-ManifestForLocal -AppName $AppName -LocalCache $LocalCache | ForEach-Object {
        $x = $_
        $x.JSON | Out-File -Path $(Join-Path $LocalBucket "$AppName.json")
        $x.Cache | ForEach-Object {
            $url = $_
            $fn = Join-Path $cacheStub $(Split-Path -Leaf $url)
            Invoke-WebRequest -Uri $url -OutFile $fn
        }
        
    }
}

Build-Cache 7zip
# $(Get-ManifestForLocal -AppName 7zip).Translate

