# CSD-CA1
![badge](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/x00205790/39415c64e57c913926b4a9c23b7bd3a9/raw/code-coverage.json)

# Project setup
## Initial build
The initial build is contained in the first-deploy.yml workflow. This workflow uses a combination of Azure CLI and Terraform to create the initial storage accounts, and container registry.

## Pipelines
The workflows are compile-and-test-prod and compile-and-test-stg and the environment for each is tied to the respective branches, these workflows cannot be triggered on any other branches.

## Housekeeping
There is a housekeeping workflow which can be used to remove old and obsolete workflows.

