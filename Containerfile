FROM debian:trixie-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y \
    && apt install -y --no-install-recommends --no-install-suggests curl git ca-certificates \
    && apt install -y --no-install-recommends --no-install-suggests bash sed grep ncat socat file findutils jq argon2 procps xxd \
    && rm -rf "/var/lib/apt/lists/*" \
    && rm -rf /var/cache/apt/archives

WORKDIR /httpsh

RUN git clone --depth 1 https://git.sakamoto.pl/domi/http.sh.git /httpsh/

RUN ./http.sh init

RUN echo 'router "/hello" "app/views/hello.shs"' >> app/routes.sh \
  && echo '#!/bin/bash\necho '\''<html><head><meta charset="utf-8"></head><body>'\''\n\nif [[ ! "${get_data[name]}" ]]; then\n\techo '\''<p>Hello World!</p>'\''\nelse\n\techo "<p>Hello $(html_encode "${get_data[name]}")!</p>"\nfi\n\necho '\''</body></html>'\''' > app/views/hello.shs

EXPOSE 1337

VOLUME /httpsh/app
VOLUME /httpsh/config
VOLUME /httpsh/storage
VOLUME /httpsh/secret

HEALTHCHECK --interval=35s --timeout=4s CMD curl --fail --insecure http://localhost:1337/ || exit 1

CMD ["/httpsh/http.sh"]
