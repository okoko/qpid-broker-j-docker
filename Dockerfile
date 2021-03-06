# Copyright 2020 Marko Kohtala <marko.kohtala@okoko.fi>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ARG usage documentation
# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG broker=8.0.0
ARG mirror=http://www.nic.funet.fi/pub/mirrors/apache.org/qpid
ARG upstream=https://www.apache.org/dist/qpid
# short, currently for OpenJDK 11 and up.
# https://openjdk.java.net/projects/jdk/14/
FROM openjdk:14-alpine3.10 AS openjdk


FROM openjdk AS unpack
RUN apk add --no-cache curl gnupg
COPY KEYS .
RUN gpg --import KEYS
ARG broker
ARG upstream
RUN curl -fLOsS ${upstream}/broker-j/${broker}/binaries/apache-qpid-broker-j-${broker}-bin.tar.gz.asc
ARG mirror
RUN curl -fLOsS ${mirror}/broker-j/${broker}/binaries/apache-qpid-broker-j-${broker}-bin.tar.gz
RUN gpg --verify apache-qpid-broker-j-${broker}-bin.tar.gz.asc apache-qpid-broker-j-${broker}-bin.tar.gz
RUN tar zxof apache-qpid-broker-j-${broker}-bin.tar.gz


FROM openjdk

# QPid broker startup scripts use bash
RUN apk add --no-cache bash

ENV QPID_WORK=/var/lib/qpid
RUN set -ex ;\
    addgroup -S qpidd ;\
    adduser -h "${QPID_WORK}" -g "Apache QPid,,," -s /sbin/nologin -G qpidd -SD qpidd ;\
    chown -R qpidd:qpidd "${QPID_WORK}"
VOLUME [ "${QPID_WORK}" ]

ENV QPID_HOME=/usr/local
WORKDIR "${QPID_HOME}"
ARG broker
COPY --from=unpack /qpid-broker/${broker} ./
COPY src/docker-entrypoint.sh /
COPY src/initial-config.json /etc/qpid/
COPY LICENSE ./

USER qpidd
EXPOSE 5672 8080
ENTRYPOINT ["/docker-entrypoint.sh"]
# For AMQP 1.0 provide some simple policies for ease of use.
# The patterns are POSIX Basic regular expressions matching the address.
# Use ^ and $ to avoid match anywhere in middle of string.
CMD ["qpid-server"]

# See https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.authors="Marko Kohtala <marko.kohtala@okoko.fi>"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/okoko/qpid-broker-j"
LABEL org.opencontainers.image.documentation="https://github.com/okoko/qpid-broker-j-docker"
LABEL org.opencontainers.image.source="https://github.com/okoko/qpid-broker-j-docker"
LABEL org.opencontainers.image.vendor="Software Consulting Kohtala Ltd"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.title="Apache Qpid Broker-J"
LABEL org.opencontainers.image.description="Apache Qpid Java AMQP Broker-J ${broker}"
#LABEL org.opencontainers.image.created="YYYY-MM-DDTHH:MM:SSZ"
LABEL org.opencontainers.image.version="${broker}"
#LABEL org.opencontainers.image.revision
