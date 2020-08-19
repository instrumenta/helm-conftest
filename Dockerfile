FROM alpine/helm:2.16.9

ENV HELM_HOME /root/.helm

RUN apk add --update --no-cache git curl bash
RUN helm init --client-only
RUN helm plugin install --debug https://github.com/instrumenta/helm-conftest

WORKDIR "/chart"

CMD ["conftest", "."]

