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

cat << EOF | kubectl apply -f -
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ScanPolicy
metadata:
  name: scan-policy
spec:
  regoFile: |
    package main
    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
    notAllowedSeverities := ["Critical","High"]
    ignoreCves := ["CVE-2021-26291", "GHSA-g36h-6r4f-3mqp", "CVE-2016-1000027"]
    contains(array, elem) = true {
      array[_] = elem
    } else = false { true }
    isSafe(match) {
      severities := { e | e := match.ratings.rating.severity } | { e | e := match.ratings.rating[_].severity }
      some i
      fails := contains(notAllowedSeverities, severities[i])
      not fails
    }
    isSafe(match) {
      ignore := contains(ignoreCves, match.id)
      ignore
    }
    deny[msg] {
      comps := { e | e := input.bom.components.component } | { e | e := input.bom.components.component[_] }
      some i
      comp := comps[i]
      vulns := { e | e := comp.vulnerabilities.vulnerability } | { e | e := comp.vulnerabilities.vulnerability[_] }
      some j
      vuln := vulns[j]
      ratings := { e | e := vuln.ratings.rating.severity } | { e | e := vuln.ratings.rating[_].severity }
      not isSafe(vuln)
      msg = sprintf("CVE %s %s %s", [comp.name, vuln.id, ratings])
    }
EOF

kubectl annotate namespace ${SESSION_NAMESPACE} secretgen.carvel.dev/excluded-from-wildcard-matching-
