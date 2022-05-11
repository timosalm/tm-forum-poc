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
  Host github.com-tm-forum-poc-ws-repo
    Hostname github.com
    IdentityFile=~/.ssh/tm-forum-poc-ws-repo
EOF

git clone https://github.com/tsalm-pivotal/tm-forum-poc.git

export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets -n metadata-store -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-read-write-client')].data.token}" | base64 -d)
tanzu insight config set-target  https://metadata-store.${TAP_INGRESS} --access-token=$METADATA_STORE_ACCESS_TOKEN
tanzu insight health

get_image_digest() {
  echo $(kubectl get kservice product-catalog-management-api-java -o jsonpath='{.spec.template.spec.containers[0].image}' | awk -F @ '{ print $2 }')
}

 get_commit() {
   echo $(kubectl get workload product-catalog-management-api-java -o jsonpath='{.status.resources[?(@.name=="source-provider")].outputs[?(@.name=="revision")].preview}')
 }
 