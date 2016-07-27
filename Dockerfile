FROM alpine:3.4
MAINTAINER Cory Christopher <cory.christopher@octanner.com>
LABEL Description="Fluentd docker image" Vendor="Fluent Organization" Version="1.1"

# Do not split this into multiple RUN!
# Docker creates a layer for every RUN-Statement
# therefore an 'apk delete build*' has no effect
RUN apk --no-cache --update add \
                            build-base \
                            ca-certificates \
                            ruby \
                            ruby-irb \
                            ruby-dev && \
    echo 'gem: --no-document' >> /etc/gemrc && \
    gem install oj && \
    gem install fluentd && \
    apk del build-base ruby-dev && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

RUN fluent-gem install fluent-plugin-kubernetes_metadata_filter fluent-plugin-elasticsearch fluent-plugin-aws-elasticsearch-service

COPY fluent.conf /etc/fluent/

COPY start.sh /start.sh

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

RUN chmod +x /start.sh

CMD ["/start.sh"]

# CMD exec fluentd -c /etc/fluent/$FLUENTD_CONF $FLUENTD_OPT

# FROM ubuntu:14.04
# MAINTAINER Alex Robinson "arob@google.com"
# MAINTAINER Jimmi Dyson "jimmidyson@gmail.com"

# # Ensure there are enough file descriptors for running Fluentd.
# RUN ulimit -n 65536

# # Disable prompts from apt.
# ENV DEBIAN_FRONTEND noninteractive

# # Install prerequisites.
# RUN apt-get update && \
#     apt-get install -y -q curl make g++ && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# # Install Fluentd.
# RUN /usr/bin/curl -L https://td-toolbelt.herokuapp.com/sh/install-ubuntu-trusty-td-agent2.sh | sh

# # Change the default user and group to root.
# # Needed to allow access to /var/log/docker/... files.
# RUN sed -i -e "s/USER=td-agent/USER=root/" -e "s/GROUP=td-agent/GROUP=root/" /etc/init.d/td-agent

# # Install the Elasticsearch Fluentd plug-in.
# RUN td-agent-gem install fluent-plugin-kubernetes_metadata_filter fluent-plugin-elasticsearch fluent-plugin-aws-elasticsearch-service fluent-plugin-record-reformer

# # Copy the Fluentd configuration file.
# COPY td-agent.conf /etc/td-agent/td-agent.conf

# # Copy start script so we can pass env variables for aws
# COPY start.sh /start.sh

# # Executable
# RUN chmod +x /start.sh

# # Run the Fluentd service.
# CMD ["/start.sh"]
