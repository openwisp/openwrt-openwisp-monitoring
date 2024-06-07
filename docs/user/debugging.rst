Debugging
=========

Debugging the *openwisp-monitoring package* can be easily done by using
the ``logread`` command:

.. code-block:: shell

    logread | grep openwisp-monitoring

In case of any issue, you can enable :doc:`verbose_mode <settings>`.

If you are in that doubt openwisp-monitoring is running at all or not, you
can check with:

.. code-block:: shell

    ps | grep openwisp-monitoring

You should see something like:

.. code-block:: shell

    2712 root      1224 S    /bin/sh /usr/sbin/openwisp-monitoring --interval 300 --monitored_interfaces ...
    2713 root      1224 S    /bin/sh /usr/sbin/openwisp-monitoring --url https://demo.openwisp.io ...

You can inspect the version of openwisp-monitoring currently installed
with:

.. code-block:: shell

    openwisp-monitoring --version
