#
# docusaurus Dockerfile
#
# https://github.com/
#

# Pull base image.
FROM debian:latest

LABEL org.opencontainers.image.authors="hihouhou < hihouhou@hihouhou.com >"

ENV DOCUSAURUS_VERSION v1.14.4

# Update & install packages
RUN apt-get update && \
    apt-get install -y gnupg2 git curl apt-transport-https

#Add yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Update & install packages
RUN apt-get update && \
    apt-get install -y yarn nodejs

# Install docusaurus
RUN git clone https://github.com/facebook/Docusaurus.git && \
    cd Docusaurus && \
    npm install

# Init website
RUN mkdir /srv/docusaurus_website && \
    cd /srv/docusaurus_website && \
    npx docusaurus-init

EXPOSE 3000  

WORKDIR /srv/docusaurus_website/website

RUN mv blog-examples-from-docusaurus blog && \
    mv ../docs-examples-from-docusaurus ../docs

#Launch docusaurus
CMD ["yarn", "start"]
