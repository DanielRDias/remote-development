########################################
# DEV image
#######################################

FROM alpine:3.11.3 as DEV
ENV TERRAFORM_VERSION=0.14.10
ENV TERRAFORM_DOCS_VERSION=v0.8.2
RUN apk add --update --upgrade --no-cache bash make git curl zsh graphviz

RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin
RUN rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*    
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

WORKDIR /app/

########################################
# TERRAFORM-DOCS image
#######################################

FROM cytopia/terraform-docs:latest AS DOCS
WORKDIR /app/

########################################
# RELEASE image
#######################################

FROM mhart/alpine-node:latest as RELEASE
RUN apk add --update --upgrade --no-cache bash make git curl zsh
# install oh-my-zsh
RUN node -v && npm -v
RUN npm install --global release-it @release-it/conventional-changelog semantic-release @semantic-release/changelog @semantic-release/git @semantic-release/commit-analyzer @semantic-release/release-notes-generator
WORKDIR /app/
