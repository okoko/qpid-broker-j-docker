#!/bin/sh

# Copyright 2019 Marko Kohtala <marko.kohtala@okoko.fi>
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

set -e

# If command starts with an option, prepend qpid-server
if [ "${1:0:1}" = '-' ]; then
    set -- qpid-server "$@"
fi

if [ "$1" = "qpid-server" ]; then

    set -- "$@" --initial-config-path "${QPIDD_ICP:-/etc/qpid/initial-config.json}"
    [ "$QPIDD_SYSTEM_PROPERTIES" ] && set -- "$@" --system-properties-file "$QPIDD_SYSTEM_PROPERTIES"
    # Where to store configuration
    [ "$QPIDD_STORE_PATH" ] && set -- "$@" --store-path "$QPIDD_STORE_PATH"
    # Default of JSON, but can be memory, DERBY, BDB, or JDBC
    [ "$QPIDD_STORE_TYPE" ] && set -- "$@" --store-type "$QPIDD_STORE_TYPE"

    # Copy config properties from environment to command line
    env | while IFS== read name value
    do
        case "$name" in
            QPIDD_CONFIG_*)
                set -- "$@" --config-property "${name#QPIDD_CONFIG_}=$value" ;;
        esac
    done
fi

exec "$@"
