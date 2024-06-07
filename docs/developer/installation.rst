Developer Installation Instructions
===================================

Compiling openwisp-monitoring
-----------------------------

This repository ships 2 OpenWrt packages:

- **netjson-monitoring**: provides
  `NetJSON DeviceMonitoring
  <https://netjson.org/docs/what.html#devicemonitoring>`_ output
- **openwisp-monitoring**: daemon which collects and sends
  `NetJSON DeviceMonitoring
  <https://netjson.org/docs/what.html#devicemonitoring>`_ data to
  `OpenWISP Monitoring
  <https://github.com/openwisp/openwisp-monitoring>`_
  It depends on **netjson-monitoring** and
  `openwisp-config
  <https://github.com/openwisp/openwisp-config>`_

The following procedure illustrates how to compile *openwisp-monitoring*, *netjson-monitoring* and their dependencies:

.. code-block:: shell

    git clone https://git.openwrt.org/openwrt/openwrt.git
    cd openwrt
    git checkout <openwrt-branch>

    # configure feeds
    echo "src-git openwisp_config https://github.com/openwisp/openwisp-config.git" > feeds.conf
    echo "src-git openwisp_monitoring https://github.com/openwisp/openwrt-openwisp-monitoring.git" >> feeds.conf
    cat feeds.conf.default >> feeds.conf
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    echo "CONFIG_PACKAGE_netjson-monitoring=y" >> .config
    echo "CONFIG_PACKAGE_openwisp-monitoring=y" >> .config
    make defconfig
    make tools/install
    make toolchain/install
    make package/openwisp-monitoring/compile

The compiled packages will go in ``bin/packages/*/openwisp``.

Alternatively, you can configure your build interactively with ``make menuconfig``, in this case
you will need to select the *openwisp-monitoring* and *netjson-monitoring* by going to ``Administration > admin > openwisp``:

.. code-block:: shell

    git clone https://git.openwrt.org/openwrt/openwrt.git
    cd openwrt
    git checkout <openwrt-branch>

    # configure feeds
    echo "src-git openwisp_config https://github.com/openwisp/openwisp-config.git" > feeds.conf
    echo "src-git openwisp_monitoring https://github.com/openwisp/openwrt-openwisp-monitoring.git" >> feeds.conf
    cat feeds.conf.default >> feeds.conf
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    make menuconfig
    # go to Administration > admin > openwisp and select the packages you need interactively
    make tools/install
    make toolchain/install
    make package/openwisp-monitoring/compile

Quality Assurance Checks
------------------------

We use `LuaFormatter <https://luarocks.org/modules/tammela/luaformatter>`_
and `shfmt <https://github.com/mvdan/sh#shfmt>`_ to format lua files and
shell scripts respectively.

Once they are installed, you can format all files by::

    ./qa-format

Run quality assurance tests with::

    #install openwisp-utils QA tools first
    pip install openwisp-utils[qa]

    #run QA checks before committing code
    ./run-qa-checks

Run tests
---------

To run the unit tests, you must install the required dependencies first;
to do this, you can take
a look at the
`install-dev.sh
<https://github.com/openwisp/openwisp-config/blob/master/install-dev.sh>`_
script.

Install test requirements::

    sudo ./install-dev.sh

You can run all unit tests by launching the dedicated script::

    ./runtests

Alternatively, you can run specific tests, e.g.::

    cd openwrt-openwisp-monitoring/tests/
    lua test_utils.lua -v
