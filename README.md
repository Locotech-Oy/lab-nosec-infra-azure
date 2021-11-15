# lab-nosec-infra-azure
A Terraform setup for testing various levels of insecure settings in Azure and how they are displayed in a security posture monitoring tool such as Prisma Cloud.

> Note! This is a setup intentionally designed to not follow best practices. It is also by no means designed to actually be a functional setup, only to demonstrate various insecure configs in various Azure services and how they could be fixed. Do not use this as a template for a real life production environment. You should run this for as little time as needed to complete a test or demonstration.

Keep in mind, when applying the Terraform templates locally, the state will be stored in the local folder as well. Prefer to run the changes through our Azure pipeline.

The different security levels have been split into their own branches, but every branch basically represents the same infrastructure. So running the terraform in one branch, then switching to another branch and running it again will change the existing setup in Azure.

```
main: all common code, instructions etc. Also starting point, all resources created but no specific security fixes, sometimes even intentionally bad config.
  |
  |-- fixed: Contains corrections to security posture

```


Resources created | Comments
---               | ---
| resource group  | this holds all the resources so that it's possible to manually delete the entire infrastructure if needed from Azure.
| vnet            | The public resources should connect to the outside world throught this network.
| storage account | with a few containers that have various levels of access.
| Web app service | Starts up a basic .NET starter site
| MySQL database  | This should not be public access at all (but is at first)