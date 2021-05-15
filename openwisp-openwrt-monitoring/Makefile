# openwisp.org
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=openwisp-monitoring
PKG_VERSION:=$(shell cat ../VERSION)
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_SOURCE_SUBDIR)
PKG_LICENSE:=GPL-3.0

include $(INCLUDE_DIR)/package.mk

define Package/openwisp-openwrt-monitoring/default
	TITLE:=OpenWISP Monitoring
	CATEGORY:=Network
	SECTION:=base
	SUBMENU:=openwisp
	PKGARCH:=all
	MAINTAINER:=Federico Capoano <f.capoano@openwisp.io>
	URL:=http://openwisp.org
endef

Package/openwisp-openwrt-monitoring=$(call Package/openwisp-openwrt-monitoring/default)

define Package/openwisp-netjson-monitoring/default
	TITLE:=NetJson Monitoring
	CATEGORY:=Network
	SECTION:=base
	SUBMENU:=openwisp
	DEPENDS:=+libubus-lua +lua-cjson
	PKGARCH:=all
	MAINTAINER:=Federico Capoano <f.capoano@openwisp.io>
	URL:=http://openwisp.org
endef

define Build/Compile
endef

Package/openwisp-netjson-monitoring=$(call Package/openwisp-netjson-monitoring/default)

define Package/openwisp-openwrt-monitoring/conffiles
/etc/config/monitoring
endef

define Package/openwisp-netjson-monitoring/install
	$(INSTALL_DIR) \
		$(1)/usr/sbin

	$(INSTALL_BIN) \
		files/sbin/netjson-monitoring.lua \
		$(1)/usr/sbin/netjson-monitoring
endef

define Package/openwisp-openwrt-monitoring/install
	$(INSTALL_DIR) \
		$(1)/usr/sbin \
		$(1)/etc/init.d \
		$(1)/etc/config

	$(INSTALL_BIN) \
		files/monitoring.agent \
		$(1)/usr/sbin/monitoring_config

	$(INSTALL_BIN) \
		files/monitoring.init \
		$(1)/etc/init.d/monitoring_config

	$(INSTALL_CONF) \
		files/monitoring.config \
		$(1)/etc/config/monitoring
endef

$(eval $(call BuildPackage,openwisp-openwrt-monitoring))
$(eval $(call BuildPackage,openwisp-netjson-monitoring))
