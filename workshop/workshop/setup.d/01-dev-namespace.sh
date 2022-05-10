#!/bin/bash
set -x
set +e

echo $APP_GIT_REPO_SSH_PRIVATE_KEY > ~/.ssh/tm-forum-poc-ws-repo
cat <<EOF >> ~/.ssh/config
  Host github.com-tm-forum-poc-ws-repo
    Hostname github.com
    IdentityFile=~/.ssh/tm-forum-poc-ws-repo
EOF

export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets -n metadata-store -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-read-write-client')].data.token}" | base64 -d)
tanzu insight config set-target  https://metadata-store.${TAP_INGRESS} --access-token=$METADATA_STORE_ACCESS_TOKEN
tanzu insight health