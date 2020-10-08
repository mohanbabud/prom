#!/bin/sh

set -ex

apt-get update && apt-get install -y --no-install-recommends curl gnupg2 ca-certificates
curl -L https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
