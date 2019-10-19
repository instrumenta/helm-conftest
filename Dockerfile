FROM alpine/helm

RUN apk add --update --no-cache git curl bash
RUN helm init --client-only
RUN helm plugin install --debug https://github.com/instrumenta/helm-conftest

WORKDIR "/chart"

CMD ["conftest", "."]

