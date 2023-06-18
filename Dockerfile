#
# Copyright (c) 2021
# Intel Corporation
#
FROM ubuntu:20.04
ARG SNYK_VERSION=1.1087.0

ENV http_proxy http://proxy-dmz.intel.com:912
ENV https_proxy http://proxy-dmz.intel.com:912
ENV no_proxy intel.com

ENV SNYK_VERSION=${SNYK_VERSION}
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      wget \
      curl \
      ca-certificates

COPY --from=golang:1.17 /usr/local/go/ /usr/local/go/
ENV PATH="/usr/local/go/bin:$PATH"

COPY --from=docker:latest /usr/local/bin/docker /usr/local/bin/docker

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs

# installing snyk with prod supported version and snyk-to-html.
RUN npm install -g snyk@${SNYK_VERSION} snyk-to-html

ENTRYPOINT [ "snyk" ]
CMD [ "test" ]
