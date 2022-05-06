**Persona: Operators**

After we have containerized our application and pushed it to the container registry and scanned it for vulnerabilities, we are now able to get all the benefits Kubernetes provides for our application by deploying it to a cluster.

**Cloud Native Runtimes for VMware Tanzu** (CNRs) simplify deploying and operating microservices on Kubernetes. They are a set of capabilities that enable us to leverage the power of Kubernetes for **Serverless** use cases without first having to master the Kubernetes API.

###### Knative
CNRs includes **Knative**, an open source community project that provides a simple, consistent layer over Kubernetes that solves common problems of deploying software, connecting disparate systems together, upgrading software, observing software, routing traffic, and scaling automatically. This layer creates a firmer boundary between the developer and the platform, allowing the developer to concentrate on the software they are directly responsible for.

The major subprojects of Knative are *Serving* and *Eventing*.
- **Serving** is responsible for deploying, upgrading, routing, and scaling. 
- **Eventing** is responsible for connecting disparate systems. Dividing responsibilities this way allows each to be developed more independently and rapidly by the Knative community.


###### Functions runtime
With TAP 1.1 a public beta of a polyglot serverless function experience for Kubernetes was released. 
It leverages Knative and new Cloud Native Buildpacks and currently supports Java and Python HTTP functions. .NET and NodeJS support is planned.

###### Future runtimes
VMware is currently working on the following additional runtimes:
- **Streaming**: A polyglot runtime that can simplify the orchestration of diverse data processing architecture patterns. By reimagining the building blocks of Spring Cloud Data Flow with polyglot-friendly and Kubernetes-native principles, the Streaming runtime will bridge the gap between application development and data ‘organization silos’.
- **Batch:** Scheduled jobs to complete tasks

##### GitOps

##### Conventions

##### Multi-cluster
