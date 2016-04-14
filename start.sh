

#!/bin/bash

sed -ie "s,ES_ENDPOINT,${ES_ENDPOINT},g" /etc/td-agent/td-agent.conf
sed -ie "s/ES_REGION/${ES_REGION}/g" /etc/td-agent/td-agent.conf

td-agent $FLUENTD_ARGS