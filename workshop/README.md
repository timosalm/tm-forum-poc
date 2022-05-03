# A workshop that demonstrates all the capabilities TAP provides for the TM Forum use-case

A [Learning Center for VMware Tanzu](https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-learning-center-about.html) workshopthat demonstrates all the capabilities TAP provides for the TM Forum use-case

## Prerequisites

- A TAP 1.1 environment with testing-scanning installed
- All the other deliverables of the TM Forum PoC installed 

## Workshop installation
Download the Tanzu CLI for Linux and the Tanzu Developer Tools for Visual Studio Code from https://network.tanzu.vmware.com/products/tanzu-application-platform to the root of this sub-directory.
Create a public project called **tap-workshop** in your registry instance. 

There is a Dockerfile in the root directory of this repo. From that root directory, build a Docker image and push it to the project you created:
```
docker build . -t <your-registry-hostname>/tap-workshop/tm-forum-poc-workshop
docker push <your-registry-hostname>/tap-workshop/tm-forum-poc-workshop
```

Copy values-example.yaml to values.yaml and set configuration values
```
cp values-example.yaml values.yaml
```
Run the installation script.
```
./install.sh
```

## Debug
```
kubectl logs -l deployment=learningcenter-operator -n learningcenter
```