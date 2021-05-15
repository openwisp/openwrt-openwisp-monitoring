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

define Package/openwisp-monitoring/default
	TITLE:=OpenWISP Monitoring
	CATEGORY:=Network
	SECTION:=base
	SUBMENU:=openwisp
	PKGARCH:=all
	MAINTAINER:=Federico Capoano <f.capoano@openwisp.io>
	URL:=http://openwisp.org
endef

Package/openwisp-monitoring=$(call Package/openwisp-monitoring/default)

define Package/netjson-monitoring/default
	TITLE:=NetJson Monitoring
	CATEGORY:=Network
	SECTION:=base
	SUBMENU:=openwisp
	DEPENDS:=+libubus-lua +lua-cjson
	PKGARCH:=all
	MAINTAINER:=Federico Capoano <f.capoano@openwisp.io>
	URL:=http://openwisp.org
endef

Package/netjson-monitoring=$(call Package/netjson-monitoring/default)

define Build/Compile
endef

define Package/openwisp-monitoring/conffiles
/etc/config/monitoring
endef

define Package/netjson-monitoring/install
	$(INSTALL_DIR) \
		$(1)/usr/sbin

	$(INSTALL_BIN) \
		files/sbin/netjson-monitoring.lua \
		$(1)/usr/sbin/netjson_monitoring
endef

define Package/openwisp-monitoring/install
	$(INSTALL_DIR) \
		$(1)/usr/sbin \
		$(1)/etc/init.d \
		$(1)/etc/config

	$(INSTALL_BIN) \
		files/monitoring.agent \
		$(1)/usr/sbin/openwisp_monitoring

	$(INSTALL_BIN) \
		files/monitoring.init \
		$(1)/etc/init.d/openwisp_monitoring

	$(INSTALL_CONF) \
		files/monitoring.config \
		$(1)/etc/config/monitoring
endef

$(eval $(call BuildPackage,openwisp-monitoring))
$(eval $(call BuildPackage,netjson-monitoring))
