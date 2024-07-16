Settings
========

.. contents:: **Table of Contents**:
    :depth: 2
    :local:

Configuration Options
---------------------

UCI configuration options must go in ``/etc/config/openwisp-monitoring``.

- ``monitored_interfaces``: interfaces that needs to be monitored,
  defaults to ``*`` for all interfaces.
- ``interval``: the periodic interval in seconds at which the agent sends
  data to the server, defaults to ``300``.
- ``verbose_mode``: can be enabled (set to ``1``) to ease :doc:`debugging
  <debugging>` in case of issues, defaults to ``0`` (disabled).
- ``required_memory``: available memory required to save data temporarily,
  defaults to ``0.05`` (5 percent).
- ``max_retries``: maximum number of retries in case of failures to send
  data to server in case of failure, defaults to ``5`` retries.
- ``bootup_delay``: maximum value in seconds of a random delay after
  bootup, defaults to ``10``, see :ref:`monitoring_agent_bootup_delay`.

In case, :ref:`maximum retries are reached <monitoring_agent_send_mode>`,
agent will try sending data again in next cycle.

.. _monitoring_agent_collecting_vs_sending:

Collecting Vs Sending
---------------------

We use two procd services in `monitoring agent
<https://github.com/openwisp/openwrt-openwisp-monitoring/blob/master/openwisp-monitoring/files/monitoring.agent>`_,
one for collecting the data and other for sending the data.

This helps handle failure in sending the data in more flexible way. Old
data saved during network connectivity issues can be sent while new data
is being collected. If old data has piled up and takes several minutes to
be uploaded, new data will be collected without waiting for the sending to
complete.

Monitoring agent uses two different modes to handle this, ``send`` and
``collect``.

.. _monitoring_agent_collect_mode:

Collect Mode
~~~~~~~~~~~~

If openwisp-monitoring agent is called with this mode, then the agent will
keep charge of collecting and saving data.

Agent will periodically check if enough memory is available. If true, data
will be collected and saved in temporary storage with the timestamp (in
UTC timezone).

Once the data is saved, a signal will be sent to the other agent to ensure
data is sent as soon as it is collected.

**Note:** Date and time on device should be set correctly. Otherwise, data
will be saved with wrong timestamp in timeseries database.

.. _monitoring_agent_send_mode:

Send Mode
~~~~~~~~~

If openwisp-monitoring agent is called with this mode, then the agent will
keep charge of sending data.

Agent will check if any data file is available in temporary storage.

If there is no data file, the agent will sleep for the time interval and
check for the data file again. This will be continued until a data file is
found. If a signal is received from the other agent, then the sleep will
be interrupted and agent will start sending data.

If agent fails to send data to the server, a randomized backoff (between 2
and 15 seconds) will be used to retry until ``max_retries`` is reached. If
all attempts of sending data failed, the agent will try to send data in
the next cycle.

If data is sent successfully, then the data file will be deleted and agent
will look for another file.

**SIGUSR1** signals are used to instantly send the data when collected.
However, the service will keep trying to send data periodically.

.. _monitoring_agent_bootup_delay:

Bootup Delay
------------

The option ``bootup_delay`` is used to delay the initialization of the
agent for a random amount of seconds after the device boots.

The value specified in this option represents the maximum value of the
range of possible random values, the minimum value being ``0``.

The default value of this option is 10, meaning that the initialization of
the agent will be delayed for a random number of seconds, this random
number being comprised between ``0`` and ``10``.

This feature is used to spread the load on the OpenWISP server when a
large amount of devices boot up at the same time after a blackout.

Large OpenWISP installations may want to increase this value.
