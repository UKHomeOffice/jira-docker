FROM openjdk:8

# Configuration variables.
ENV JIRA_HOME     /var/atlassian/jira
ENV JIRA_INSTALL  /opt/atlassian/jira
ARG JIRA_VERSION=7.2.4

# Install Atlassian JIRA and helper tools and setup initial home
# directory structure.
RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends xmlstarlet apt-utils \
    && apt-get clean \
    && useradd -U jira \
    && chown -R jira:jira "/var" \
    && chown -R jira:jira "/opt"
    
USER jira:jira

RUN mkdir -p ${JIRA_INSTALL}
RUN wget -q -O - https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_VERSION}.tar.gz | tar xz --strip=1 -C ${JIRA_INSTALL} || \
    wget -q -O - http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-${JIRA_VERSION}.tar.gz | tar xz --strip=1 -C ${JIRA_INSTALL}

RUN mkdir -p                   "${JIRA_HOME}" \
    && mkdir -p                "${JIRA_HOME}/caches/indexes" \
    && chmod -R 700            "${JIRA_HOME}" \
    && chown -R jira:jira      "${JIRA_HOME}" \
    && mkdir -p                "${JIRA_INSTALL}/conf/Catalina" \
    && rm -f                   "${JIRA_INSTALL}/lib/postgresql-9.1-903.jdbc4-atlassian-hosted.jar" \
    && curl -Ls                "https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar" -o "${JIRA_INSTALL}/lib/postgresql-9.4.1212.jar" \
    && chmod -R 700            "${JIRA_INSTALL}/conf" \
    && chmod -R 700            "${JIRA_INSTALL}/logs" \
    && chmod -R 700            "${JIRA_INSTALL}/temp" \
    && chmod -R 700            "${JIRA_INSTALL}/work" \
    && chown -R jira:jira      "${JIRA_INSTALL}/conf" \
    && chown -R jira:jira      "${JIRA_INSTALL}/logs" \
    && chown -R jira:jira      "${JIRA_INSTALL}/temp" \
    && chown -R jira:jira      "${JIRA_INSTALL}/work" \
    && sed --in-place          "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" \
    && echo -e                 "\njira.home=$JIRA_HOME" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties" \
    && touch -d "@0"           "${JIRA_INSTALL}/conf/server.xml" \
    && cp -r "${JIRA_INSTALL}/conf" "${JIRA_INSTALL}/original_conf"

# add a runtime arg to extend the timeout for plugin installs
RUN sed -i 's/^JVM_SUPPORT_RECOMMENDED_ARGS=""/JVM_SUPPORT_RECOMMENDED_ARGS="-Datlassian.plugins.enable.wait=300"/' ${JIRA_INSTALL}/bin/setenv.sh

# Expose default HTTP connector port.
EXPOSE 8080

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["/var/atlassian/jira", "/opt/atlassian/jira/logs", "/opt/atlassian/jira/conf"]

# Set the default working directory as the installation directory.
WORKDIR /var/atlassian/jira

COPY "docker-entrypoint.sh" "/"
ENTRYPOINT ["/docker-entrypoint.sh"]

# Run Atlassian JIRA as a foreground process by default.
CMD ["/opt/atlassian/jira/bin/catalina.sh", "run"]
