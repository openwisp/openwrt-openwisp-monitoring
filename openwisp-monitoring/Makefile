# openwisp.org
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=openwisp-monitoring
PKG_VERSION:=$(shell cat ../VERSION)
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_SOURCE_SUBDIR)
PKG_MAINTAINER:=Federico Capoano <f.capoano@openwisp.io>
PKG_LICENSE:=GPL-3.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/openwisp-monitoring
	TITLE:=OpenWISP Monitoring agent
	CATEGORY:=Administration
	SECTION:=admin
	SUBMENU:=openwisp
	DEPENDS:=+netjson-monitoring +openwisp-config
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

define Build/Compile
endef

define Package/openwisp-monitoring/conffiles
/etc/config/openwisp-monitoring
endef

define Package/netjson-monitoring/install
	$(INSTALL_DIR) \
		$(1)/usr/sbin \
		$(1)/usr/libexec \
		$(1)/usr/lib/lua/openwisp-monitoring \
		$(1)/usr/lib/openwisp-monitoring

	$(INSTALL_BIN) \
		files/sbin/netjson-monitoring.lua \
		$(1)/usr/libexec/netjson-monitoring

	$(INSTALL_BIN) \
		files/netjson-monitoring \
		$(1)/usr/sbin/netjson-monitoring

	$(INSTALL_DATA) \
		files/lib/openwisp-monitoring/dhcp.lua \
		$(1)/usr/lib/lua/openwisp-monitoring/dhcp.lua

	$(INSTALL_DATA) \
		files/lib/openwisp-monitoring/interfaces.lua \
		$(1)/usr/lib/lua/openwisp-monitoring/interfaces.lua

	$(INSTALL_DATA) \
		files/lib/openwisp-monitoring/monitoring.lua \
		$(1)/usr/lib/lua/openwisp-monitoring/monitoring.lua

	$(INSTALL_DATA) \
		files/lib/openwisp-monitoring/utils.lua \
		$(1)/usr/lib/lua/openwisp-monitoring/utils.lua

	$(INSTALL_DATA) \
		files/lib/openwisp-monitoring/neighbors.lua \
		$(1)/usr/lib/lua/openwisp-monitoring/neighbors.lua

	$(INSTALL_DATA) \
		files/lib/openwisp-monitoring/resources.lua \
		$(1)/usr/lib/lua/openwisp-monitoring/resources.lua

	$(INSTALL_DATA) \
		files/lib/openwisp-monitoring/wifi.lua \
		$(1)/usr/lib/lua/openwisp-monitoring/wifi.lua

	$(CP) ../VERSION $(1)/usr/lib/openwisp-monitoring/

endef

define Package/openwisp-monitoring/install
	$(INSTALL_DIR) \
		$(1)/usr/sbin \
		$(1)/etc/init.d \
		$(1)/etc/config \
		$(1)/usr/lib/openwisp-monitoring \
		$(1)/etc/hotplug.d/openwisp

	$(INSTALL_BIN) \
		files/monitoring.agent \
		$(1)/usr/sbin/openwisp-monitoring

	$(INSTALL_BIN) \
		files/monitoring.init \
		$(1)/etc/init.d/openwisp-monitoring
	
	$(INSTALL_BIN) \
		files/openwisp-monitoring.hotplug \
		$(1)/etc/hotplug.d/openwisp/openwisp-monitoring

	$(INSTALL_CONF) \
		files/monitoring.config \
		$(1)/etc/config/openwisp-monitoring

endef

$(eval $(call BuildPackage,openwisp-monitoring))
$(eval $(call BuildPackage,netjson-monitoring))
