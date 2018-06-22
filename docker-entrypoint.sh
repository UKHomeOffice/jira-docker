#!/bin/bash

cp /home/jira/templates/dbconfig.xml ${JIRA_HOME}/dbconfig.xml
cp /home/jira/templates/server.xml ${JIRA_INSTALL}/conf/server.xml


# update the server.xml connection settings from environment variables
sed 's/{{SERVER_PORT}}/'"${SERVER_PORT}"'/' -i ${JIRA_INSTALL}/conf/server.xml
sed 's/{{SERVER_REDIRECT_PORT}}/'"${SERVER_REDIRECT_PORT}"'/' -i ${JIRA_INSTALL}/conf/server.xml
sed 's/{{SERVER_PROXY_NAME}}/'"${SERVER_PROXY_NAME}"'/' -i ${JIRA_INSTALL}/conf/server.xml
sed 's/{{SERVER_PROXY_PORT}}/'"${SERVER_PROXY_PORT}"'/' -i ${JIRA_INSTALL}/conf/server.xml

# update the dbconfig.xml settings from environment variables
sed 's/{{DATABASE_HOST}}/'"${DATABASE_HOST}"'/' -i ${JIRA_HOME}/dbconfig.xml
sed 's/{{DATABASE_PORT}}/'"${DATABASE_PORT}"'/' -i ${JIRA_HOME}/dbconfig.xml
sed 's/{{DATABASE_NAME}}/'"${DATABASE_NAME}"'/' -i ${JIRA_HOME}/dbconfig.xml
sed 's/{{DATABASE_USERNAME}}/'"${DATABASE_USERNAME}"'/' -i ${JIRA_HOME}/dbconfig.xml
sed 's/{{DATABASE_PASSWORD}}/'"${DATABASE_PASSWORD}"'/' -i ${JIRA_HOME}/dbconfig.xml
sed 's/{{DATABASE_SCHEMA_NAME}}/'"${DATABASE_SCHEMA_NAME}"'/' -i ${JIRA_HOME}/dbconfig.xml

exec "$@"
