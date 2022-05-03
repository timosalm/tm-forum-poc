set -x

ytt template -f resources -f values.yaml --ignore-unknown-comments | kapp deploy -n tap-install -a tmf-workshops -f- --diff-changes --yes
kubectl delete pod -l deployment=learningcenter-operator -n learningcenter
