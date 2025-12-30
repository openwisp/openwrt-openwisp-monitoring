Change log
==========

0.3.0 [2025-10-27]
------------------

Bugfixes
~~~~~~~~

- Switch to portable df output (df -P) `#153
  <https://github.com/openwisp/openwrt-openwisp-monitoring/issues/153>`_.
- Fixed issue where WiFi client data was sent even when no clients were
  connected.
- Added check to ensure data file exists before sending to prevent errors
  `#102
  <https://github.com/openwisp/openwrt-openwisp-monitoring/issues/102>`_.
- Ignored duplicate IP addresses in network configuration.

0.2.1 [2024-11-07]
------------------

Bugfixes
~~~~~~~~

- Fixed compiling the package without the ``rpcd-mod-iwinfo`` dependency.

0.2.0 [2024-09-25]
------------------

Features
~~~~~~~~

- Added ``bootup_delay`` option to control delay before the agent starts
  on boot.
- Restart the agent when ``openwisp-config`` starts or restarts to ensure
  configuration consistency.
- Added ``htmode`` to wireless interface stats for enhanced monitoring.
- Added bitrate, quality, and connected AP information for wireless
  "station" mode.
- Added support for using the ``cacert`` and ``capath`` configuration
  options defined in the ``openwisp-config`` configuration file for
  ``curl`` command.
- Allowed compiling the package without the ``rpcd-mod-iwinfo``
  dependency. This is beneficial for space-constrained devices that do not
  have a WiFi card.

Changes
~~~~~~~

- Allowed WireGuard protocol to be used as a virtual interface type.
- Improved sending of accumulated data by adding a random pause after
  every 10 successful requests.
- Enhanced mesh station information handling.
- Stopped sending data after receiving repeated 404 responses to prevent
  unnecessary retries.
- Skipped adding the wireless section if the WiFi channel is not
  available.

Backward incompatible
+++++++++++++++++++++

- Implemented a randomized backoff mechanism for HTTP requests, replacing
  the previous exponential backoff approach.

Bugfixes
~~~~~~~~

- Applied a workaround for devices that incorrectly report zero CPUs,
  ensuring at least one CPU is assumed.
- Prevented the addition of bridge members when the list is empty to avoid
  unnecessary configurations.
- Discarded data when receiving a bad request response from the server to
  avoid re-sending corrupted data.
- Used the correct device network section for STP on OpenWrt versions
  greater than 21.
- Skipped adding empty DHCP lease tables to avoid unnecessary data
  processing.
- Avoided including mobile signal data if it is not available.

0.1.1 [2022-06-08]
------------------

- Fixed crash when ULA prefix is not available

0.1.0 [2022-05-10]
------------------

First release. Features:

- ``netjson-monitoring`` package
- ``openwisp-monitoring`` package
- resilient metric sending: when the device cannot communicate with the
  server, the metrics are stored in memory until there's enough free
  memory and sent later when the communication is established again
