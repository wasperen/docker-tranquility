FROM centos:7
MAINTAINER Willem van Asperen

ENV TRANQUILITY_HOME /opt/tranquility

# core OS dependencies and configuration
RUN yum -y update \
    && yum -y install \
      java-1.8.0-openjdk

RUN rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
    localedef --quiet -c -i en_US -f UTF-8 en_US.UTF-8

RUN mkdir ${TRANQUILITY_HOME} \
    && useradd -ms /bin/bash -d ${TRANQUILITY_HOME} tranquility

# install tranquility
RUN cd /tmp \
    && curl -O http://static.druid.io/tranquility/releases/tranquility-distribution-0.8.0.tgz \
    && tar xzf tranquility-distribution-0.8.0.tgz \
    && mv tranquility-distribution-0.8.0 ${TRANQUILITY_HOME} \
    && ln -s ${TRANQUILITY_HOME}/tranquility-distribution-0.8.0 ${TRANQUILITY_HOME}/current

ADD entrypoint.sh ${TRANQUILITY_HOME}/entrypoint.sh
RUN chmod +x ${TRANQUILITY_HOME}/entrypoint.sh \
    && chown tranquility: -R ${TRANQUILITY_HOME}

ADD tranquility-server.json ${TRANQUILITY_HOME}/tranquility-server.json

EXPOSE 8200

USER tranquility
WORKDIR ${TRANQUILITY_HOME}/current
ENTRYPOINT ["../entrypoint.sh"]
