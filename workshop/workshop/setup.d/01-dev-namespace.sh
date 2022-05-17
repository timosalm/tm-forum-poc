#!/bin/bash
set -x
set +e

mkdir -p ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts
echo $APP_GIT_REPO_SSH_PRIVATE_KEY | sed 's/----- /-----\n/g' | sed 's/ -----/\n-----/g' > ~/.ssh/tm-forum-poc-ws-repo
chmod 400 ~/.ssh/tm-forum-poc-ws-repo
eval `ssh-agent -s`
ssh-add ~/.ssh/tm-forum-poc-ws-repo

cat <<EOF >> ~/.ssh/config
  Host github.com
    Hostname github.com
    User git
    IdentityFile=~/.ssh/tm-forum-poc-ws-repo
EOF

git config --global user.email "learningcenter-ws@vmware.com"
git config --global user.name "Learning Center Workshop"

git clone https://github.com/tsalm-pivotal/tm-forum-poc.git

export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets -n metadata-store -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-read-write-client')].data.token}" | base64 -d)
tanzu insight config set-target  https://metadata-store.${TAP_INGRESS} --access-token=$METADATA_STORE_ACCESS_TOKEN
tanzu insight health

docker login $CONTAINER_REGISTRY_HOSTNAME -u $CONTAINER_REGISTRY_USERNAME -p $CONTAINER_REGISTRY_PASSWORD

REGISTRY_PASSWORD=$CONTAINER_REGISTRY_PASSWORD kp secret create registry-credentials --registry ${CONTAINER_REGISTRY_HOSTNAME} --registry-user ${CONTAINER_REGISTRY_USERNAME}
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "registry-credentials"}, {"name": "tanzu-net-credentials"}]}'
