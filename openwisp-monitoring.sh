uuid=$(uci get openwisp.http.uuid)
key=$(uci get openwisp.http.key)
base_url=$(uci get openwisp.http.url)
verify_ssl=$(uci get openwisp.http.verify_ssl)
monitored_interfaces=$(uci get openwisp.http.monitored_interfaces)
url="$base_url/api/v1/monitoring/device/$uuid/?key=$key"
data=$(/usr/sbin/netjson-monitoring "$monitored_interfaces")
if [ "$verify_ssl" = 0 ]; then
    curl_command='curl -k'
else
    curl_command='curl'
fi
# send data via POST
$($curl_command -H "Content-Type: application/json" \
                -X POST \
                -d "$data" \
                -v $url)
