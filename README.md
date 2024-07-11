# Configure docker container with Terraform

## Scenario

`Terraform` is a great tool to use for infrastructure as code. Assuming you are using containers to run your pipeline code, how do you make `Terraform` available in the containers?

Second, when using `Terraform` you have to store its *state files* somewhere. A bad idea is to store them locally or inside the repository. A good idea is to store them somewhere in a remote location. Good options are `GitLab` or some cloud providers.

## Prerequisites

A Linux or MacOS machine for local development. If you are running Windows, you first need to set up the *Windows Subsystem for Linux (WSL)* environment.

You need `docker cli` and `docker-compose` on your machine for testing purposes, and/or on the machines that run your pipeline.
You can check both of these by running the following commands:
```sh
docker --version
docker-compose --version
```

Depending on where you intend to store the `Terraform` *state files* you need the following:

For `GitLab`:
First of all, you need `GitLab` access:
- GITLAB_USERNAME
- GITLAB_TOKEN
Second, you also need `Terraform` credentials:
- TF_HTTP_USERNAME
- TF_HTTP_PASSWORD

For `AWS` you need authentification credentials:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_KEY

## Implementation
The easiest way to make `Terraform` available in your containers is to build them on top of an image that is preconfigured to use `Terraform`:
```sh
FROM hashicorp/terraform:1.5.0
```
You should use a specific version here instead of *latest*.

In the sample code provided from this point on, I will assume that the company you work for is called *my-company*. Just change it to something that fits better.

## Implementation with GitLab

In the `Terraform` project, you have to correctly configure the location of the stored files:
```sh
terraform {
  required_version = "1.5.0"
  # Configure the backend to store the terraform state files
  # Credentials can be provided by using the TF_HTTP_USERNAME, and TF_HTTP_PASSWORD environment variables. (https://developer.hashicorp.com/terraform/language/settings/backends/http)
  backend "http" {
    address = "https://git.my-company.io/api/v4/projects/123/terraform/state/remote-terraform-state-files-123-cluster"
    lock_address = "https://git.my-company.io/api/v4/projects/123/terraform/state/remote-terraform-state-files-123-cluster/lock"
    unlock_address = "https://git.my-company.io/api/v4/projects/123/terraform/state/remote-terraform-state-files-123-cluster/lock"
    lock_method = "POST"
    unlock_method = "DELETE"
  }
}
```
Note that you will have to change *my-company* to something that fits better. In this configuration, you must also specify the ID of the `GitLab` repository, so change *123* to the ID of your `GitLab` repository. You can rename *remote-terraform-state-files-123-cluster* to something else, but it is a good idea to follow a pattern you define.

If you want to use `Terraform` to interact with `GitLab`, you must configure its provider:
```sh
terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "16.5.0"
    }
  }
}

# Configure the GitLab Provider
# Credentials can be provided by using the GITLAB_TOKEN environment variables. (https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs)
provider "gitlab" {
  base_url = "https://git.my-company.io/api/v4/"
}
```
Note that you will have to change *my-company* to something that fits better in this case also. Note that the `GitLab` credentials are not found here. They can be provided via specific environment variables.

## Implementation with AWS

In the `Terraform` project, you have to correctly configure the location of the stored files:
```sh
terraform {
  required_version = "1.5.0"
  backend "s3" {
    bucket = "aws-my-company-s3-remote-terraform-state-files"
    key    = "core.tf"
    region = "eu-central-1"
  }
}
```
Note that you will have to change *my-company* to something that fits better. You can also change the bucket name pattern with something else. Change the region from *eu-central-1* to something else if necessary.

You must also configure the `AWS` provider:
```sh
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.75.1"
    }
  }
}

# Configure the AWS Provider
# Credentials can be provided by using the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and optionally AWS_SESSION_TOKEN environment variables. (https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
provider "aws" {
  region = var.AWSRegion
}
```
Note that you will have to change *my-company* to something that fits better in this case also. Note that the `AWS` credentials are not found here. They can be provided via specific environment variables.

## Usage

Navigate to the root of the git repository and run the following command:
```sh
sh runGitLab.sh 
```
for the `GitLab` test or:
```sh
sh runAWS.sh 
```
for the `AWS` test.

Whichever script you choose to run, the following happens:
1) the first command builds the docker image and tags it as correspondingly
2) the docker image copies the `Terraform` project and the *starting script* to an appropriate location. This is the place where the necessary environment variables are provided.
3) the second command uses docker-compose to create and run the container. The container runs the *starting script* which only runs
```sh
terraform init && terraform validate && terraform apply -auto-approve
```
For more complex projects, a lot more can happen at this point.
