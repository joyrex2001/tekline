################
## Base image ## -------------------------------------------------------------
################

FROM alpine:latest as base

RUN apk add curl jq bash git

###############
## Downloads ## --------------------------------------------------------------
###############

FROM base as build

RUN mkdir /downloads

## Download kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
    &&  chmod 755 ./kubectl \
    &&  mv ./kubectl /downloads/

## Download kustomize
RUN curl -L0 $(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases \
              | grep browser_download | grep linux | grep kustomize_v | cut -d '"' -f 4 | head -n 1) \
         -o kustomize_latest.tar.gz \
    &&  tar xf kustomize_latest.tar.gz \
    &&  chmod 755 ./kustomize \
    &&  mv ./kustomize /downloads/

## Download tkn
RUN curl -LO https://github.com/tektoncd/cli/releases/download/v0.30.0/tkn_0.30.0_Linux_x86_64.tar.gz \
    && tar xvzf tkn_0.30.0_Linux_x86_64.tar.gz -C /downloads tkn \
    && chmod 755 /downloads/tkn

#################
## Final image ## ------------------------------------------------------------
#################

FROM base

COPY --from=build /downloads /bin

USER 1001
