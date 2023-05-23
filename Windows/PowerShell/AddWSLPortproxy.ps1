Param($port_from, $port_to, $distribution)
# Write-Output $port_from $port_to
# wsl2のportとホストOSのportのプロキシ設定を追加するスクリプト

if([string]::IsNullOrEmpty($distribution))
{
    Write-Host "distribution name is empty. Use default distribution."
    $wsl_ip = wsl hostname -I | wsl cut -f 1 -d " "
}
else
{
    Write-Host $distribution;
    $wsl_ip = wsl -d $distribution hostname -I | wsl cut -f 1 -d " "
}

Write-Output 'wsl guest ip' $wsl_ip

$host_ip = (Get-NetIPAddress -AddressFamily "IPv4" -PrefixOrigin "Dhcp").IPAddress
Write-Output 'host ip' $host_ip

for ($port=$port_from; $port -lt $port_to; $port++){
    Write-Output("port:"+$port)
    netsh interface portproxy delete v4tov4 listenport=$port listenaddr=$host_ip
    netsh interface portproxy add v4tov4 listenport=$port listenaddr=$host_ip connectport=$port connectaddress=$wsl_ip
}

netsh interface portproxy show v4tov4
