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
            $dir=(Get-Item -Path ".").FullName
            Get-ChildItem "$dir\src\" | ForEach-Object {
                $Dll = $_
                add-type -path $Dll.FullName
            }
        }
        catch{
            Write-Output 'Error, could not load dll'
            return
        }
        #Starting the mDNS discover process with googlecast query
        try{
            $Result=[Zeroconf.ZeroconfResolver]::ResolveAsync("_googlecast._tcp.local.")
        }
        catch{
            Write-Output 'Error, could not start mDNS resolver'
            return
        }
        #Return the discover result 
        return $Result
    }

function Discover_ips{
#Function used by the 'Cast' function to harvest ipadresses
    #Tries to load mDNS Dll's files from the .\src\ folder
    try{
        $dir=(Get-Item -Path ".").FullName
        Get-ChildItem "$dir\src\" | ForEach-Object {
            $Dll = $_
            add-type -path $Dll.FullName
        }
    }
    catch{
        Write-Output 'Error, could not load dll'
        return
    }
    #Starting the mDNS discover process with googlecast query
    try{
        $result=[Zeroconf.ZeroconfResolver]::ResolveAsync("_googlecast._tcp.local.")
    }
    catch{
        Write-Output 'Error, could not start mDNS resolver'
        return
    }
    #Returns the ipaddresses that was found
    $Ips=$Result | Select-Object result | Select-Object -ExpandProperty * | Select-Object IPAddresses | Select-Object -ExpandProperty *
    return $Ips
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
    param(
        [Parameter(Mandatory = $false)]
        [string]
        $Video='dQw4w9WgXcQ',

        [Parameter(Mandatory = $false)]
        [string[]]
        $IpAddress
    )
    #Creating a json object with the video that will be sent later as a post request
    $Body=@{'v'= $Video}
    #If parameter ipaddress have value, skip discover function and go straight to casting.
    if ($IpAddress.Length -gt 0){
        $Ips=$IpAddress
    }
    #If parameter ipaddress dosent have value, than get ipaddresses from discover_ips function
    else{
        try{
            $ips=Discover_ips
        }
        catch{
            return
        }
    }
    #Loop thru all the ipaddresses and make a post request to the Youtube Api of every address.
    foreach ($Ip in $Ips){
        $Ip=$Ip+":8008"
        try{
            Invoke-WebRequest -Uri "http://$Ip/apps/YouTube" -Method POST -Body $Body -ContentType 'application/json' -UserAgent 'curl/7.60.0' -TimeoutSec 5 | Out-Null
            Write-Output "Casting to $Ip"
        }
        catch{
            Write-Output "Error, could not cast to Chromecast $Ip"
        }
    }
}
#export the functions
Export-ModuleMember -Function Cast,Discover