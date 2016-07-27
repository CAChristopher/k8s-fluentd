#!/bin/bash

# SIGTERM-handler
term_handler() {
  exit 143; # 128 + 15 -- SIGTERM
}

trap 'kill ${!}; term_handler' SIGTERM

sed -ie "s/ES_AWS_ACCESS_KEY_ID/${ES_AWS_ACCESS_KEY_ID}/g" /etc/fluent/fluent.conf
sed -ie "s/ES_AWS_SECRET_ACCESS_KEY/${ES_AWS_SECRET_ACCESS_KEY}/g" /etc/fluent/fluent.conf

set -x

sed -ie "s,ES_ENDPOINT,${ES_ENDPOINT},g" /etc/fluent/fluent.conf
sed -ie "s/ES_REGION/${ES_REGION}/g" /etc/fluent/fluent.conf

fluentd -c /etc/fluent/fluent.conf $FLUENTD_ARGS