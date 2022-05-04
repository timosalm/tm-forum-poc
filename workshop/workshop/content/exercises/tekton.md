Because we all make mistakes, testing the implementation of the application is important. 
To reduce the effort for testing our application on every change, it's recommended to automate the test execution.

Developers know best how to run their for example unit and UI tests. 
This is why TAP provides the flexibility to
- make development teams responsible for the creation of the test automation for their applications 
- implement the test automation for the tools and frameworks used in an organization by DevOps teams or operators

TAP includes **Tekton** for the implementation of the test automation or other Continous Integration(CI) tasks that are not handleded by other components. Tekton is a cloud-native, open-source solution for building CI/CD systems. 
Due to the fact that most of the organizations already have other CI/CD tools like Jenkins, VMware is working on addining first-class support for the most popular ones. If 

 Technically it's already possible to use e.g. Jenkins instead of Tekton for the test automation.

For our use-case each development team is responsible for the creation of the test automation of their application which gives them the flexibility to use the frameworks and tools they prefer. 