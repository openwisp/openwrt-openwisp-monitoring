set -e
apt-get update
# install cmake and git
apt-get install -y cmake git
# install lua
apt-get install -y lua5.1 liblua5.1-0-dev luarocks
# update links to shared libraries
ldconfig -v
# install luacheck
luarocks install luacheck
