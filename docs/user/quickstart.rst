Quickstart Guide
================

To install the pre-compiled monitoring packages, proceed to update
the package feeds:

.. code-block:: shell

    opkg update

Then install the ``netjson-monitoring`` and ``openwisp-monitoring``
packages from our `latest builds
<https://downloads.openwisp.io/?prefix=openwisp-monitoring/latest/>`_:

.. code-block:: shell

    cd /tmp
    wget <URL>
    opkg install ./<file-just-downloaded>

Where ``<URL>`` is the URL of the pre-compiled package.

For a list of the latest built images, take a look at
`downloads.openwisp.io
<https://downloads.openwisp.io/?prefix=openwisp-monitoring/>`_.

**If you need to compile the package yourself**, see :ref:`Compiling
openwisp-monitoring <compiling_openwrt_openwisp_monitoring>`.

Once installed *openwisp-monitoring* needs to be configured (see
:doc:`Configuration options <settings>`) and then started with:

.. code-block:: shell

    /etc/init.d/openwisp-monitoring restart

To ensure the agent is working correctly find out how to perform debugging
in the :doc:`debugging` section.
