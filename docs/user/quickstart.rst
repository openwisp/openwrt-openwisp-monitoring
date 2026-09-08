Quick Start Guide
=================

Install the Monitoring Agent on your OpenWrt system with:

.. code-block:: shell

    # OpenWrt >= 25.12
    apk update
    apk install openwisp-monitoring

    # OpenWrt <= 24.10
    opkg update
    opkg install openwisp-monitoring

.. note::

    The latest builds published on `downloads.openwisp.io
    <https://downloads.openwisp.io/>`_ are available only in APK format as
    of September 2025. Earlier builds used opkg. To compile packages for a
    custom or legacy OpenWrt version, refer to
    :ref:`compiling_openwrt_openwisp_monitoring`.

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
