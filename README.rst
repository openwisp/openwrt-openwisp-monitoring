===========================
openwisp-netjson-monitoring
===========================

.. image:: http://img.shields.io/github/release/openwisp/lua-monitoring.svg
   :target: https://github.com/openwisp/lua-monitoring/releases

.. image:: https://img.shields.io/gitter/room/nwjs/nw.js.svg?style=flat-square
   :target: https://gitter.im/openwisp/general
   :alt: support chat

------------

.. image:: http://netjsonconfig.openwisp.org/en/latest/_images/openwisp.org.svg
  :target: http://openwisp.org

.. contents:: **Table of Contents**:
 :backlinks: none
 :depth: 3

Configuration options
---------------------

UCI configuration options must go in ``/etc/config/monitoring``.

- ``monitored_interfaces``: interfaces that needs to be monitored, defaults to ``*`` for all interfaces.
- ``interval``: time in seconds between checks for changes to the configuration, defaults to ``300``

Compiling openwisp-netjson-monitoring
-------------------------

There are 2 packages for *openwisp-netjson-monitoring*:

- **netjson-monitoring**: provides NetJSON Device Monitoring output
- **openwisp-monitoring**: depends on **netjson-monitoring** and **openwisp-config**

The following procedure illustrates how to compile both *openwisp-monitoring* and *netjson-monitoring*:

.. code-block:: shell

    git clone https://github.com/openwrt/openwrt.git openwrt
    cd openwrt
    git checkout openwrt-19.07

    # configure feeds
    echo "src-git monitoring https://github.com/openwisp/lua-monitoring.git" > feeds.conf
    cat feeds.conf.default >> feeds.conf
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    # any arch/target is fine because the package is architecture indipendent
    arch="ar71xx"
    echo "CONFIG_TARGET_$arch=y" > .config;
    echo "CONFIG_PACKAGE_openwisp-monitoring=y" >> .config
    echo "CONFIG_PACKAGE_netjson-monitoring=y" >> .config
    make defconfig
    make tools/install
    make toolchain/install
    make package/openwisp-netjson-monitoring/compile

The compiled packages will go in ``bin/packages/*/openwisp``.

Alternatively, you can configure your build interactively with ``make menuconfig``, in this case
you will need to select the *openwisp-monitoring* and *netjson-monitoring* by going to ``Network > openwisp``:

.. code-block:: shell

    git clone https://github.com/openwrt/openwrt.git openwrt
    cd openwrt
    git checkout openwrt-19.07

    # configure feeds
    echo "src-git openwisp https://github.com/openwisp/openwisp-config.git" > feeds.conf
    cat feeds.conf.default >> feeds.conf
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    make menuconfig
    # go to Network > openwisp and select the packages you need interactively
    make tools/install
    make toolchain/install
    make package/openwisp-netjson-monitoring/compile

Once installed *openwisp-monitoring* needs to be configured (see `Configuration options`_)
and then started with::

    /etc/init.d/openwisp_monitoring restart

Contributing
------------

Please read the `OpenWISP contributing guidelines
<http://openwisp.io/docs/developer/contributing.html>`_.

Changelog
---------

See `CHANGELOG <https://github.com/openwisp/lua-monitoring/blob/master/CHANGELOG.rst>`_.

License
-------

See `LICENSE <https://github.com/openwisp/lua-monitoring/blob/master/LICENSE>`_.

Support
-------

See `OpenWISP Support Channels <http://openwisp.org/support.html>`_.
