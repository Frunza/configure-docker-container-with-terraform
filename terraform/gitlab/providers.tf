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
