terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 0.5.0"
    }
  }
}
locals {
  # GitHub organization name to strip from repository paths
  github_org = "exeloncorp"
 
  # Extract just the repository name without the org prefix
  repo_name = trimprefix(var.repository_id, "${local.github_org}/")
 
  # Format repository name by removing special characters and converting to lowercase
  formatted_repo_name = lower(replace(local.repo_name, "/[^a-zA-Z0-9]/", "-"))
}

provider "azuredevops" {
  # Authentication is configured using environment variables:
  # AZDO_ORG_SERVICE_URL and AZDO_PERSONAL_ACCESS_TOKEN
}

variable "project_name" {
  description = "Azure DevOps project name"
  type        = string
}

variable "repository_id" {
  description = "Full GitHub repository path (org/repo)"
  type        = string
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
  default     = "exeloncorp"  # Can be overridden if needed
}

variable "pipelines" {
  description = "List of pipeline configurations"
  type = list(object({
    name_prefix = string
    owning_team = string
    branch      = string
    yaml_path   = string
    environment = optional(string, "")
    suffix      = optional(string, "")
  }))
}

    
resource "azuredevops_build_definition" "pipelines" {
  count        = length(var.pipelines)
  project_id   = var.project_name
  name         = "${local.formatted_repo_name}-${var.pipelines[count.index].name_prefix}-${var.pipelines[count.index].owning_team}-${var.pipelines[count.index].environment}${var.pipelines[count.index].suffix != "" ? "-" : ""}${var.pipelines[count.index].suffix}"
  path         = "\\${var.pipelines[count.index].owning_team}\\${local.formatted_repo_name}"

  repository {
    repo_type   = "TfsGit"
    repo_id     = var.repository_id
    branch_name = var.pipelines[count.index].branch
    yml_path    = var.pipelines[count.index].yaml_path
  }
}

output "pipeline_details" {
  description = "Details of the provisioned Azure DevOps pipelines"
  value = [
    for pipeline in azuredevops_build_definition.pipelines : {
      name = pipeline.name
      path = pipeline.path
      yaml_path = pipeline.repository[0].yml_path
      branch = pipeline.repository[0].branch_name
    }
  ]
}
