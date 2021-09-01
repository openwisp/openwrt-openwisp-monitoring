# openwisp.org
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=openwrt-openwisp-monitoring
PKG_VERSION:=$(shell cat ../VERSION)
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_SOURCE_SUBDIR)
PKG_MAINTAINER:=Federico Capoano <f.capoano@openwisp.io>
PKG_LICENSE:=GPL-3.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/openwisp-monitoring/default
	TITLE:=OpenWISP Monitoring agent ($(2) variant)
	CATEGORY:=Administration
	SECTION:=admin
	SUBMENU:=openwisp
	DEPENDS:=+netjson-monitoring $(3)
	VARIANT:=$(1)
	PKGARCH:=all
	URL:=http://openwisp.org
endef

define Package/netjson-monitoring
	TITLE:=NetJson Monitoring
	CATEGORY:=Administration
	SECTION:=admin
	SUBMENU:=openwisp
	DEPENDS:=+libubus-lua +lua-cjson +rpcd +rpcd-mod-iwinfo
	PKGARCH:=all
	URL:=http://openwisp.org
endef

Package/openwisp-monitoring-openssl=$(call Package/openwisp-monitoring/default, openssl, OpenSSL, +openwisp-config-openssl)
Package/openwisp-monitoring-mbedtls=$(call Package/openwisp-monitoring/default, mbedtls, mbedTLS, +openwisp-config-mbedtls)
Package/openwisp-monitoring-wolfssl=$(call Package/openwisp-monitoring/default, wolfssl, WolfSSL, +openwisp-config-wolfssl)
Package/openwisp-monitoring-nossl=$(call Package/openwisp-monitoring/default, nossl, No SSL, +openwisp-config-nossl)


define Build/Compile
endef

define Package/openwisp-monitoring-$(BUILD_VARIANT)/conffiles
/etc/config/monitoring
endef

define Package/netjson-monitoring/install
	$(INSTALL_DIR) \
		$(1)/usr/sbin \
		$(1)/usr/lib/lua/openwisp_monitoring

	$(INSTALL_BIN) \
		files/sbin/netjson-monitoring.lua \
		$(1)/usr/sbin/netjson_monitoring

	$(INSTALL_DATA) \
		files/lib/openwisp_monitoring/dhcp.lua \
		$(1)/usr/lib/lua/openwisp_monitoring/dhcp.lua

	$(INSTALL_DATA) \
		files/lib/openwisp_monitoring/interfaces.lua \
		$(1)/usr/lib/lua/openwisp_monitoring/interfaces.lua

	$(INSTALL_DATA) \
		files/lib/openwisp_monitoring/monitoring.lua \
		$(1)/usr/lib/lua/openwisp_monitoring/monitoring.lua

	$(INSTALL_DATA) \
		files/lib/openwisp_monitoring/utils.lua \
		$(1)/usr/lib/lua/openwisp_monitoring/utils.lua

	$(INSTALL_DATA) \
		files/lib/openwisp_monitoring/neighbors.lua \
		$(1)/usr/lib/lua/openwisp_monitoring/neighbors.lua

	$(INSTALL_DATA) \
		files/lib/openwisp_monitoring/resources.lua \
		$(1)/usr/lib/lua/openwisp_monitoring/resources.lua

	$(INSTALL_DATA) \
		files/lib/openwisp_monitoring/wifi.lua \
		$(1)/usr/lib/lua/openwisp_monitoring/wifi.lua

endef

define Package/openwisp-monitoring-$(BUILD_VARIANT)/install
	$(INSTALL_DIR) \
		$(1)/usr/sbin \
		$(1)/etc/init.d \
		$(1)/etc/config \
		$(1)/etc/openwisp/monitoring

	$(INSTALL_BIN) \
		files/monitoring.agent \
		$(1)/usr/sbin/openwisp_monitoring

	$(INSTALL_BIN) \
		files/monitoring.init \
		$(1)/etc/init.d/openwisp_monitoring

	$(INSTALL_CONF) \
		files/monitoring.config \
		$(1)/etc/config/openwisp_monitoring

	$(CP) ../VERSION $(1)/etc/openwisp/monitoring/

endef

$(eval $(call BuildPackage,openwisp-monitoring-openssl))
$(eval $(call BuildPackage,openwisp-monitoring-mbedtls))
$(eval $(call BuildPackage,openwisp-monitoring-wolfssl))
$(eval $(call BuildPackage,openwisp-monitoring-nossl))
$(eval $(call BuildPackage,netjson-monitoring))
