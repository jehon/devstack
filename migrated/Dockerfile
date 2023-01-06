
FROM debian:testing

# For supervisor
EXPOSE 9001

ENV DEBIAN_FRONTEND=noninteractive
ENV "LC_ALL" "C.UTF-8"
ENV PATH "/setup/bin:${PATH}"

#
# https://docs.docker.com/engine/reference/builder/#shell
#
# change for RUN blablabla
# does NOT change RUN [ bla, bla, bla ]
#
SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

RUN apt update \
    && apt install --yes python3-pip

#
# pip:
#   install goes to /usr/local/bin
#
#   - netaddr: for ipaddr filters
#
RUN python3 -m pip install ansible netaddr passlib \
    && python3 -m pip show ansible \
    && ansible --version

# docker specific files
COPY root /
COPY built /

RUN find /setup -name .gitkeep -delete \
    && mkdir /setup/tmp \
    && chmod 777 /setup/log /setup/tmp \
    && cp -f /setup/ansible/tmp/* /setup/ansible/inventory/ \
    && mkdir -p /etc/jehon/restricted && echo 123 > /etc/jehon/restricted/ansible-key

RUN cd /setup/ansible && ansible-playbook setup.yml --limit devcontainer --connection=local

# RUN apt update

# RUN apt install -y jehon && apt update

# RUN apt install -y jehon-os-debian && apt update

# RUN apt install jehon-packages jehon-hardware-docker supervisor docker-ce docker-ce-cli containerd.io docker-compose-plugin

# RUN useradd user -G "sudo,docker,fuse" --password=pass \
#     && echo "user:pass" | sudo chpasswd

# https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact
ENTRYPOINT [ "/setup/exec" ]
