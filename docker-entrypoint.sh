#!/bin/bash

# check if the `server.xml` file has been changed since the creation of this
# Docker image. If the file has been changed the entrypoint script will not
# perform modifications to the configuration file.

if [ ! -f "${JIRA_INSTALL}/conf/server.xml" ]; then
    cp ${JIRA_INSTALL}/original_conf/* ${JIRA_INSTALL}/conf/
fi

exec "$@"
