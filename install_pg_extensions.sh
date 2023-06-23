#!/bin/bash
set -euxo pipefail

# calling syntax: install_pg_extensions.sh [extension1] [extension2] ...

# install extensions
EXTENSIONS="$@"
# cycle through extensions list
for EXTENSION in ${EXTENSIONS}; do
    # is it an extension found in apt?
    if apt-cache show "postgresql-${PG_MAJOR}-${EXTENSION}" &> /dev/null; then
        # install the extension
        apt-get install -y "postgresql-${PG_MAJOR}-${EXTENSION}"
        continue
    fi
    
    # special case: timescaledb
    if [ "$EXTENSION" == "timescaledb" ]; then
        # dependencies
        apt-get install apt-transport-https lsb-release wget -y

        # repository
        echo "deb https://packagecloud.io/timescale/timescaledb/debian/" \
            "$(lsb_release -c -s) main" \
            > /etc/apt/sources.list.d/timescaledb.list

        # key
        wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey \
            | gpg --dearmor > /etc/apt/trusted.gpg.d/timescaledb.gpg
        
        apt-get update
        apt-get install --yes \
            timescaledb-tools \
            timescaledb-toolkit-postgresql-${PG_MAJOR} \
            timescaledb-2-loader-postgresql-${PG_MAJOR} \
            timescaledb-2-${TIMESCALEDB_VERSION}-postgresql-${PG_MAJOR}

        # cleanup
        apt-get remove apt-transport-https lsb-release wget --auto-remove -y

        continue
    fi

    # extension not found/supported
    echo "Extension '${EXTENSION}' not found/supported"
    exit 1
done
