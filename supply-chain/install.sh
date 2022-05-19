set -x

ytt template -f custom-supply-chain.yaml -f values.yaml --ignore-unknown-comments | k apply -f - -f api-conformance-source-template.yaml -f api-conformance-run-template.yaml
