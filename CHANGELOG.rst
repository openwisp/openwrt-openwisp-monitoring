Change log
^^^^^^^^^^

0.1.1 [2022-06-08]
==================

- Fixed crash when ULA prefix is not available

0.1.0 [2022-05-10]
==================

First release. Features:

- ``netjson-monitoring`` package
- ``openwisp-monitoring`` package
- resilient metric sending:
  when the device cannot communicate with the server, the metrics are
  stored in memory until there's enough free memory and sent later
  when the communication is established again
