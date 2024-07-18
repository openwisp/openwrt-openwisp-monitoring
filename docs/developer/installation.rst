Developer Documentation
=======================

.. include:: ../partials/developer-docs.rst

.. contents:: **Table of Contents**:
    :depth: 2
    :local:

.. _compiling_openwrt_openwisp_monitoring:

Compiling the Monitoring Agent
------------------------------

This repository ships 2 OpenWrt packages:

- **netjson-monitoring**: provides `NetJSON DeviceMonitoring
  <https://netjson.org/docs/what.html#devicemonitoring>`_ output
- **openwisp-monitoring**: daemon which collects and sends `NetJSON
  DeviceMonitoring <https://netjson.org/docs/what.html#devicemonitoring>`_
  data to :doc:`OpenWISP Monitoring </monitoring/index>` It depends on
  **netjson-monitoring** and :doc:`openwisp-config
  </openwrt-config-agent/index>`

The following procedure illustrates how to compile *openwisp-monitoring*,
*netjson-monitoring* and their dependencies:

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

Alternatively, you can configure your build interactively with ``make
menuconfig``, in this case you will need to select the
*openwisp-monitoring* and *netjson-monitoring* by going to
``Administration > admin > openwisp``:

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

Once they are installed, you can format all files by:

.. code-block:: shell

    ./qa-format

Run quality assurance tests with:

.. code-block:: shell

    #install openwisp-utils QA tools first
    pip install openwisp-utils[qa]

    #run QA checks before committing code
    ./run-qa-checks

Run tests
---------

To run the unit tests, you must install the required dependencies first;
to do this, you can take a look at the `install-dev.sh
<https://github.com/openwisp/openwrt-openwisp-monitoring/blob/master/install-dev.sh>`_
script.

Install test requirements:

.. code-block:: shell

    sudo ./install-dev.sh

You can run all unit tests by launching the dedicated script:

.. code-block:: shell

    ./runtests

Alternatively, you can run specific tests, e.g.:

.. code-block:: shell

    cd openwrt-openwisp-monitoring/tests/
    lua test_utils.lua -v
