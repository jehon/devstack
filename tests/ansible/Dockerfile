
FROM debian:testing

ADD built /

RUN --mount=type=cache,target=/var/cache/apt apt update && /ansible-requirements.sh
