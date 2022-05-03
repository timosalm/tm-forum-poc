#!/bin/bash
set -x
set +e

jq ". + { \"java.server.launchMode\": \"Standard\", \"tanzu.sourceImage\": \"${CONTAINER_REGISTRY_HOSTNAME}/tap-wkld/spring-sensors-source\", \"tanzu.namespace\": \"${SESSION_NAMESPACE}\", \"redhat.telemetry.enabled\": false }" /home/eduk8s/.local/share/code-server/User/settings.json | sponge /home/eduk8s/.local/share/code-server/User/settings.json