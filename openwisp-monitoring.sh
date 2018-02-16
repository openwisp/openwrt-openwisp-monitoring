uuid=$(uci get openwisp.http.uuid)
key=$(uci get openwisp.http.key)
base_url=$(uci get openwisp.http.url)
url="$base_url/api/v1/monitoring/device/$uuid/?key=$key"
data=$(/usr/sbin/netjson-monitoring)
# send data via POST
curl -H "Content-Type: application/json" \
     -X POST -d "$data" $url -I
