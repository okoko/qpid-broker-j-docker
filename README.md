# Apache QPid Broker-J AMQP broker docker image

AMQP messaging broker Docker image.

For quick look at the browser, compile and start the image with

    docker build -t qpid-broker-j .
    docker run --rm -it -p 8080:8080 -p 5672:5672 qpid-broker-j

Open browser to http://localhost:8080/ and login using guest/guest for
user/password. Try it with some AMQP client on port 5672.

## Environment variables

| Name                                          | Default                       | Description              |
| :-------------------------------------------- | :---------------------------- | :----------------------- |
| QPIDD_ICP                                     | /etc/qpid/initial-config.json | --initial-config-path    |
| QPIDD_SYSTEM_PROPERTIES                       |                               | --system-properties-file |
| QPIDD_STORE_PATH                              | /var/lib/qpid/config.json     | --store-path             |
| QPIDD_STORE_TYPE                              | JSON                          | --store-type             |
| QPIDD_CONFIG_broker.name                      | Broker                        |                          |
| QPIDD_CONFIG_qpid.amqp_port                   | 5672                          |                          |
| QPIDD_CONFIG_qpid.http_port                   | 8080                          |                          |
| QPIDD_CONFIG_qpid.port.default_amqp_protocols | all                           | AMQP_1_0 etc.            |

To have fixed configuration at start of broker, you can configure the
broker using the any management channel, and copy the config.json to be
used as the initial configuration. The set environment variables
`QPIDD_ICP` to the configuration and `QPIDD_STORE_TYPE=memory`.
