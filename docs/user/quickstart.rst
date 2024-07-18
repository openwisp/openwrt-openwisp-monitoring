Quick Start Guide
=================

To install the Monitoring Agent on your OpenWrt system, follow these
steps.

Download and install the latest builds of both `netjson-monitoring` and
`openwisp-monitoring` from `downloads.openwisp.io
<http://downloads.openwisp.io/?prefix=openwisp-monitoring/>`_. Copy the
URL of the IPK file you want to download, then run the following commands
on your OpenWrt device:

.. code-block:: shell

    cd /tmp  # /tmp runs in memory
    opkg update
    # Install netjson-monitoring first
    wget <URL-just-copied>
    opkg install ./<file-just-downloaded>
    # Install openwisp-monitoring last
    wget <URL-just-copied>
    opkg install ./<file-just-downloaded>

Replace ``<URL-just-copied>`` with the URL of the respective package from
`downloads.openwisp.io
<http://downloads.openwisp.io/?prefix=openwisp-monitoring/>`_.

Now you can start the agent:

.. code-block:: shell

    /etc/init.d/openwisp-monitoring start

.. seealso::

    - For troubleshooting and debugging, refer to :doc:`debugging`.
    - To learn more about the configuration options of the monitoring
      agent, refer to :doc:`settings`.
    - For instructions on how to compile the package, refer to
      :ref:`compiling_openwrt_openwisp_monitoring`.
    - Read about the complementary :doc:`Config Agent
      </openwrt-config-agent/index>`.
