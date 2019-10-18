# Apache QPid Broker-J AMQP broker docker image

AMQP messaging broker Docker installation.

## Environment variables

| Name                        | Default                       | Description              |
| :-------------------------- | :---------------------------- | :----------------------- |
| QPIDD_ICP                   | /etc/qpid/initial-config.json | --initial-config-path    |
| QPIDD_SYSTEM_PROPERTIES     |                               | --system-properties-file |
| QPIDD_STORE_PATH            | /var/lib/qpid/config.json     | --store-path             |
| QPIDD_STORE_TYPE            | JSON                          | --store-type             |
| QPIDD_CONFIG_broker.name    | Broker                        |                          |
| QPIDD_CONFIG_qpid.amqp_port | 5672                          |                          |
| QPIDD_CONFIG_qpid.http_port | 8080                          |                          |

To have fixed configuration at start of broker, you can configure the
broker using the any management channel, and copy the config.json to be
used as the initial configuration. The set environment variables
`QPIDD_ICP` to the configuration and `QPIDD_STORE_TYPE=memory`.
