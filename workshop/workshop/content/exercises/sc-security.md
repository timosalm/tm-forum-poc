**Persona: Operators**

In the next step the provided **source code will be scanned** for known vulnerabilities using [Grype](https://github.com/anchore/grype). After the container image building, there is also a step for **image scanning** using Grype.

For source and image scans to happen, scan policies must exist in the same namespace as the Workload which can be done during the automated provisioning of new namespaces. It defines how to evaluate whether the artifacts scanned are compliant, for example allowing one to be either very strict, or restrictive about particular vulnerabilities found.
```editor:open-file
file: supplychain/config/scan-policy.yaml
```

###### Viewing scan status
VMware is working on making the status of the source code and container scans available via a "security analyst" dashboard in the UI and also the Supply Chain view.

**TODO***
In the meantime, it's possible to fetch the results via the tanzu CLI's insight plugin.
```terminal:execute
command: tanzu insight source vulnerabilities --commit
clear: true
```
```terminal:execute
command: tanzu insight image vulnerabilities --digest
clear: true
```

As alternative, it's possible to directly view the results via kubectl and the custom resources.
```terminal:execute
command: kubectl describe sourcescans product-catalog-management-api-java
clear: true
```
```terminal:execute
command: kubectl describe imagescans product-catalog-management-api-java
clear: true
```

###### Container signing

The Sign part of the supply chain provides an admission WebHook that:
- Verifies signatures on container images used by Kubernetes resources.
- Enforces policy by allowing or denying container images from running based on configuration.
- Adds metadata to verified resources according to their verification status.
- It intercepts all resources that create Pods as part of their lifecycle.

This component uses **cosign** as its backend for signature verification and is compatible only with cosign signatures. 

**By default, once installed, this component does not include any policy resources and does not enforce any policy.** The operator must create a ClusterImagePolicy resource in the cluster before the WebHook can perform any verifications

