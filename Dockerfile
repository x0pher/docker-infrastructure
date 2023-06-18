FROM ubuntu:22.04

ENV SCRIPTS_ROOT=/resources/scripts

RUN apt-get update && apt-get install tar wget unzip dumb-init -y && apt-get clean
COPY --from=amr-registry.caas.intel.com/rbhe-public/intel-root-ca-certs:1.1 /ssl/*.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

ADD ./resources/ /resources/
RUN ${SCRIPTS_ROOT}/install_mcafee.sh "$(ls -A /resources/mcafee/linux_*.tar.gz | tail -n 1)"
RUN chmod +x ${SCRIPTS_ROOT}/*.sh
RUN ln -s ${SCRIPTS_ROOT}/scan.sh /usr/local/bin/scan.sh \
    && chmod 777 /usr/local/uvscan

#ENV ENV_DEFS_URL=http://update.nai.com/products/commonupdater
# Nexus3 Proxy to update.nai.com
ENV ENV_DEFS_URL=https://hec-mcafee-proxy.intel.com/repository/mcafee-defs/commonupdater
ENV ENV_SCAN_OPTS="--analyze --mime  --program --recursive --unzip --threads 4 --summary --verbose"

ENTRYPOINT ["/resources/scripts/entrypoint.sh"]
