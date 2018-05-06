# JIRA Docker

> NB. This is not the version maintained by the ACP team


[![Docker Repository on Quay](https://quay.io/repository/ukhomeofficedigital/jira-docker/status "Docker Repository on Quay")](https://quay.io/repository/ukhomeofficedigital/jira-docker)

## Prerequisites

### Database

This JIRA docker image uses a PostgreSQL database for its backend.

### Reverse Proxy

This JIRA docker image is expected to be deployed behind a reverse proxy. The proxy is responsible for providing SSL termination.

### Environment variables

The image requires the following environment variables to be set as part of the deployment as they are used to set the server's proxy and database connections at runtime.

Environment variable | Description | Example
-------------------- | ----------- | -------
SERVER_PORT          | The port that the JIRA container is listening on | 8080
SERVER_REDIRECT_PORT | The port that the proxy container is listening on | 10443
SERVER_PROXY_NAME    | The host name of the proxy | jira.example.com
SERVER_PROXY_PORT    | The external port on the proxy | 443
DATABASE_HOST        | Database server host name  | db.example.com
DATABASE_PORT        | Database server port | 5432
DATABASE_NAME        | Database name | jiradb
DATABASE_USERNAME    | Database username | jira
DATABASE_PASSWORD    | Database user's password | supersecret
DATABASE_SCHEMA_NAME | Database schema name | public


## Credits

The following people have contributed to the development of this project:

- [@tomfitzherbert](https://github.com/tomfitzherbert)

## Licensing

This project is released under the MIT license.