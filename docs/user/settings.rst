Settings
========

.. contents:: **Table of Contents**:
    :depth: 2
    :local:

Configuration Options
---------------------

UCI configuration options should be placed in
``/etc/config/openwisp-monitoring``.

- ``monitored_interfaces``: Specifies the interfaces to be monitored.
  Defaults to ``*``, meaning all interfaces.
- ``interval``: Sets the interval in seconds for the agent to send data to
  the server. The default is ``300`` seconds. If changed, it's **highly
  advised** to update the :ref:`monitoring_tolerance_interval` setting on
  the server as well.
- ``verbose_mode``: Can be enabled by setting to ``1`` to assist in
  :doc:`debugging <debugging>`. The default is ``0`` (disabled).
- ``required_memory``: Minimum available memory required to temporarily
  store data. Defaults to ``0.05`` (5 percent).
- ``max_retries``: Number of failed upload attempts in a retry cycle
  before logging a persistent failure. The default is ``5``. The agent
  keeps trying after each cycle, with the failure backoff continuing to
  increase.
- ``bootup_delay``: Maximum value, in seconds, of a random delay after
  boot-up. Defaults to ``10``. See :ref:`monitoring_agent_bootup_delay`.

.. _monitoring_agent_collecting_vs_sending:

Collecting vs. Sending
----------------------

The `monitoring agent
<https://github.com/openwisp/openwrt-openwisp-monitoring/blob/master/openwisp-monitoring/files/monitoring.agent>`_
uses two procd services: one for collecting data and another for sending
it.

This setup allows for more flexible handling of data transmission
failures. Data collected during network outages can be sent later, while
new data continues to be collected. If there is a backlog of data to
upload, the collection process will continue independently.

The monitoring agent operates in two modes: ``send`` and ``collect``.

.. _monitoring_agent_collect_mode:

Collect Mode
~~~~~~~~~~~~

When the OpenWISP monitoring agent operates in this mode, it is
responsible for collecting and storing data.

The agent periodically checks if there is enough memory available. If
sufficient memory is detected, data will be collected and saved in
temporary storage with a timestamp (in UTC).

Once the data is stored, a signal is sent to the other agent to ensure the
data is transmitted promptly.

.. important::

    Ensure that the date and time on the device are correctly set.
    Incorrect timestamps can lead to inaccurate data in the time series
    database.

.. _monitoring_agent_send_mode:

Send Mode
~~~~~~~~~

When operating in this mode, the OpenWISP monitoring agent handles data
transmission.

The agent checks for available data files in temporary storage. If no data
files are found, the agent will wait for the specified interval and check
again. This process continues until data files are detected. If a signal
is received from the other agent, the wait will be interrupted, and the
agent will start sending data.

The agent sends accumulated snapshots in chronological order. New
snapshots wait behind older data, because the server calculates traffic
increments from previously processed snapshots. When there is no backlog,
new data is sent promptly.

When an upload fails, the agent waits for a random interval between one
second and a maximum that doubles after each failure: 10, 20, 40, 80, 160,
then 300 seconds. The maximum stays at 300 seconds until an upload
succeeds. Reaching ``max_retries`` logs the failure but does not reset
this backoff. Connection attempts time out after 10 seconds, and complete
requests after 60 seconds. A timed-out request may already have been
accepted by the server.

During backlog recovery, the agent pauses for a random interval between
one and 60 seconds between uploads. After consecutive successful uploads
equal to 10 percent of the backlog at the start of a pacing stage, rounded
up and with a minimum of 10 successes, the maximum pause decreases to 30
seconds. After another such stage, it decreases to 15 seconds. The backlog
is counted again at each stage. A retryable failure resets the pacing to
60 seconds. The server accepting a request does not guarantee its
background queue has finished processing it.

Upon successful data transmission, the corresponding data file is deleted.
An HTTP 400 response also discards the rejected snapshot. An HTTP 404
response causes the agent to shut down if the configuration agent is no
longer running; otherwise it is retried. New data continues to be
collected while sending is delayed. The existing memory safeguard may
discard older files when available memory is low, and slower recovery
increases that exposure.

**SIGUSR1** signals wake the sender when it is idle, but do not interrupt
failure backoff or backlog pacing. A service restart resets the in-memory
backoff and pacing stages. Temporary snapshots are stored under ``/tmp``
and do not survive a device reboot.

.. _monitoring_agent_bootup_delay:

Boot-Up Delay
-------------

The ``bootup_delay`` option introduces a random delay during the agent's
initialization after the device boots.

This option specifies the maximum value for the random delay, with a
minimum value of ``0``.

The default setting is 10, meaning the agent's initialization will be
delayed by a random number of seconds, ranging from ``0`` to ``10``.

This feature is designed to distribute the load on the OpenWISP server
when a large number of devices boot simultaneously after a power outage.

Large OpenWISP installations may benefit from increasing this value.
