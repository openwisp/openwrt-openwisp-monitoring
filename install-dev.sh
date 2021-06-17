#!/bin/sh
set -e
apt-get update
#install cmake and git
apt-get install -y cmake git
#install lua
apt-get install -y lua5.1 liblua5.1-0-dev luarocks
#install json-c
git clone https://github.com/json-c/json-c.git --depth=1
cd json-c && cmake . && make install && cd ..  || { echo 'Installing json-c failed!' ; exit 1; }
# install openwrt libubox and uci
git clone https://git.openwrt.org/project/libubox.git --depth=1
cd libubox && cmake . && make install && cd .. || { echo 'Installing libubox failed!' ; exit 1; }
git clone https://git.openwrt.org/project/uci.git --depth=1
cd uci && cmake . && make install && cd .. || { echo 'Installing uci failed!' ; exit 1; }
#install nixio
luarocks install https://raw.githubusercontent.com/Neopallium/nixio/master/nixio-scm-0.rockspec
# update links to shared libraries
ldconfig -v
# install luaunit
luarocks install luaunit
# install luacheck
luarocks install luacheck
# install lua-cjson
luarocks install lua-cjson
#clean
rm -rf json-c libubox uci
