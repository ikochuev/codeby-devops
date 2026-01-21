FROM fluent/fluentd:v1.19-debian-1

USER root
RUN fluent-gem install fluent-plugin-elasticsearch -v 6.0.0 \
    && gem uninstall elasticsearch -aIx || true \
    && gem install elasticsearch -v 6.8.0 \
    && fluent-gem install fluent-plugin-grok-parser

USER fluent
