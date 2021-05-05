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
	TITLE:=OpenWISP NetJson Monitoring
	CATEGORY:=Administration
	SECTION:=admin
	SUBMENU:=openwisp
	PKGARCH:=all
	MAINTAINER:=Federico Capoano <f.capoano@openwisp.io>
	URL:=http://openwisp.org
endef

Package/openwisp-monitoring=$(call Package/openwisp-openwrt-monitoring/default)

define Build/Compile
endef

define Package/openwisp-monitoring/install
	$(INSTALL_DIR) \
		$(1)/usr/sbin \
		$(1)/etc/crontabs \
		$(1)/etc/openwisp \

	$(INSTALL_BIN) \
		files/post-reload-hook \
		$(1)/etc/openwisp/post-reload-hook

	$(INSTALL_BIN) \
		files/sbin/update-openwisp-packages \
		$(1)/usr/sbin/update-openwisp-packages

	$(INSTALL_BIN) \
		files/cronjob \
		$(1)/etc/crontabs/root

	$(INSTALL_BIN) \
		files/sbin/netjson-monitoring.lua \
		$(1)/usr/sbin/netjson-monitoring

	$(INSTALL_BIN) \
		files/sbin/openwisp-monitoring.sh \
		$(1)/usr/sbin/openwisp-monitoring
endef

$(eval $(call BuildPackage,openwisp-monitoring))
