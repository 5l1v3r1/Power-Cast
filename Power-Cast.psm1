function Discover{
<#
.SYNOPSIS
    Retrieve all the Cromecast units
.DESCRIPTION
    Retrieve information on all Chromecast units in your multicast domain
.EXAMPLE
    Discover
    Retrieve data on all the Chromecast devices in your multicast domain
.NOTES
    https://github.com/cube0x0/
#>
#Tries to load mDNS Dll's files from the .\src\ folder
    try{
        $dir=(Get-Module power-cast).path.TrimEnd('Power-Cast.psm1')
        Get-ChildItem "$dir\src\" | ForEach-Object {
            add-type -path $_.FullName
        }
    }
    catch{
        Write-Warning 'Error, could not load dll'
        return
    }
    #Starting the mDNS discover process with googlecast query
    try{
        return [Zeroconf.ZeroconfResolver]::ResolveAsync("_googlecast._tcp.local.").result
    }
    catch{
        Write-warning 'Error, could not start mDNS resolver'
        return
    }
}

function Cast{
<#
.SYNOPSIS
    Cast youtube or rickroll to chromecast[s]
.DESCRIPTION
    Cast youtube or rickroll to chromecast[s]
.PARAMETER IpAddress
    Specify the IP on chromecast that you want to cast to, default is all
.PARAMETER IpAddress
    Specify the Video that you want to cast, default is ricky
.EXAMPLE
    Cast
    Cast rick to every chromecast in your LAN
.EXAMPLE
    Cast -Video dQw4w9WgXcQ -IpAdress 192.168.1.48
    Cast rick to 192.168.1.48
.NOTES
    https://github.com/cube0x0/
#>  
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]
        $Video='dQw4w9WgXcQ',

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $IPAddresses = (Discover).IPAddresses
    )
    $Body=@{'v'= $Video}
    foreach ($IP in $IPAddresses){    
        $address = ('http://' + $IP + ':8080/apps/YouTube').trim() 
        Invoke-WebRequest -Uri $address -Method POST -Body $Body -ContentType 'application/json' -UserAgent 'curl/7.60.0' -TimeoutSec 10 | Out-Null
    }
}
#export functions
Export-ModuleMember -Function Cast,Discover

