#!/bin/sh

# set ENV defaults
MESSAGE_TYPE=${MESSAGE_TYPE:-$KAFKA_TOPIC}
KAFKA_SERVERS=${KAFKA_SERVERS:-'localhost:9092'}
ES_INDEX=${ES_INDEX:-$KAFKA_TOPIC}
BATCH_SIZE=${BATCH_SIZE:-1000}
GROUPID=${GROUPID:-$KAFKA_TOPIC\_$ES_INDEX}
TEMPLATE_NAME=${TEMPLATE_NAME:-'kafka'}

# JAVA_HOME is invalid in this base image
unset JAVA_HOME

# inject ENVs into placeholders
sed -i "s#__BOOTSTRAP_SERVERS__#$KAFKA_SERVERS#" /logstash/config/logstash.conf
sed -i "s#__MESSAGETYPE__#$MESSAGE_TYPE#" /logstash/config/logstash.conf
sed -i "s#__KAFKATOPIC__#$KAFKA_TOPIC#" /logstash/config/logstash.conf
sed -i "s#__ESINDEX__#$ES_INDEX#" /logstash/config/logstash.conf
sed -i "s#__ESURL__#$ES_URL#" /logstash/config/logstash.conf
sed -i "s#__FLUSHSIZE__#$BATCH_SIZE#" /logstash/config/logstash.conf
sed -i "s#__GROUPID__#$GROUPID#" /logstash/config/logstash.conf
sed -i "s#__TEMPLATE_NAME__#$TEMPLATE_NAME#" /logstash/config/logstash.conf
sed -i "s#__OFFSET_RESET__#$OFFSET_RESET#" /logstash/config/logstash.conf

# Debug mode?
if [ "x$DEBUG" != "x" ]; then
  sed -i 's#output {#output {\n  stdout {\n    codec => "rubydebug"\n  }\n#' /logstash/config/logstash.conf
fi

cat /logstash/config/logstash.conf
exec /logstash/bin/logstash -f /logstash/config/logstash.conf --debug --verbose
