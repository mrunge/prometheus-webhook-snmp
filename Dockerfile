FROM registry.access.redhat.com/ubi8:8.2

USER root

COPY build/repos/opstools.repo /etc/yum.repos.d/opstools.repo

RUN dnf -y install python3-cherrypy python3-PyYAML python3-pysnmp \
                   python3-dateutil python3-click git \
                   prometheus-webhook-snmp \
                   python3-prometheus_client procps-ng telnet lsof && dnf clean all

ENV SNMP_COMMUNITY="public"
ENV SNMP_PORT="162"
ENV SNMP_HOST="localhost"
ENV SNMP_RETRIES="5"
ENV SNMP_TIMEOUT="1"
ENV ALERT_OID_LABEL="oid"

EXPOSE 9099

CMD exec /usr/bin/prometheus-webhook-snmp --debug --snmp-port=$SNMP_PORT \
  --snmp-host=$SNMP_HOST --snmp-community=$SNMP_COMMUNITY \
  --alert-oid-label=$ALERT_OID_LABEL run

