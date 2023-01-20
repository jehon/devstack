
FROM debian:testing

ADD built /

RUN --mount=type=cache,target=/var/cache/apt apt update && /ansible-requirements.sh

RUN python -m  pip cache dir

RUN --mount=type=cache,target=/root/.cache/pip /ansible-install.sh

ENV PATH="/.python/bin:$PATH"
ENV PYTHONPATH="/.python/:$PYTHONPATH"

RUN ansible --version
