#!/bin/sh
set -e
apt-get update
# install cmake and git
apt-get install -y cmake git
# install shellcheck
apt-get install shellcheck
# install lua
apt-get install -y lua5.1 liblua5.1-0-dev luarocks
# install json-c
git clone --branch json-c-0.16 https://github.com/json-c/json-c.git --depth=1
{ cd json-c && cmake . && make install && cd ..; } || { echo 'Installing json-c failed!' && exit 1; }
# install openwrt libubox and uci
git clone https://git.openwrt.org/project/libubox.git --depth=1
{ cd libubox && cmake . && make install && cd ..; } || { echo 'Installing libubox failed!' && exit 1; }
git clone https://git.openwrt.org/project/uci.git --depth=1
{ cd uci && cmake . && make install && cd ..; } || { echo 'Installing uci failed!' && exit 1; }
# install nixio
luarocks install https://raw.githubusercontent.com/openwisp/nixio/master/nixio-scm-0.rockspec
# install luaformatter
git clone --recurse-submodules https://github.com/Koihik/LuaFormatter.git
{ cd LuaFormatter && cmake . && make install && cd ..; } || { echo 'Installing LuaFormatter failed' && exit 1; }
# update links to shared libraries
ldconfig -v
# install luaunit
luarocks install luaunit
# install luacheck
luarocks install luacheck
# install lua-cjson
luarocks install lua-cjson
# install luacov-coveralls
luarocks install luacov-coveralls
# clean
rm -rf json-c libubox uci LuaFormatter
