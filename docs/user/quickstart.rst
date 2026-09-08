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

Development Builds
------------------

If you need an unreleased feature or bug fix, try the development version
from `downloads.openwisp.io <https://downloads.openwisp.io/>`_. It
provides APK packages built by our continuous integration. Before
installing one, add the OpenWISP public key to the APK keyring:

.. code-block:: shell

    cat > /etc/apk/keys/openwisp-monitoring.pem <<'EOF'
    -----BEGIN PUBLIC KEY-----
    MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEYhhsie+759Mk34fJso4cDHVeLNeE
    277qiiRySdHKYQNx8KV1RGd1ynm+5m+Z3RUl1BMYAAqi8Tip1+6q+DgEiQ==
    -----END PUBLIC KEY-----
    EOF

Then download the matching ``netjson-monitoring`` and
``openwisp-monitoring`` APK files from `the latest build
<https://downloads.openwisp.io/?prefix=openwisp-monitoring/latest/>`_ and
install them together. ``apk`` verifies their signatures with the
installed public key.

.. code-block:: shell

    apk add /tmp/netjson-monitoring_*.apk /tmp/openwisp-monitoring_*.apk

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
