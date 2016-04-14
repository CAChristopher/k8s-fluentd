

#!/bin/bash

# SIGTERM-handler
term_handler() {
  exit 143; # 128 + 15 -- SIGTERM
}

trap 'kill ${!}; term_handler' SIGTERM

sed -ie "s,ES_ENDPOINT,${ES_ENDPOINT},g" /etc/td-agent/td-agent.conf
sed -ie "s/ES_REGION/${ES_REGION}/g" /etc/td-agent/td-agent.conf


td-agent $FLUENTD_ARGS -o /var/log/td-agent/td-agent.log 