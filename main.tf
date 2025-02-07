terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 0.5.0"
    }
  }
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
  description = "Azure DevOps repository ID"
  type        = string
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
  name         = "${var.pipelines[count.index].name_prefix}-${var.pipelines[count.index].owning_team}-${var.pipelines[count.index].environment}${var.pipelines[count.index].suffix != "" ? "-" : ""}${var.pipelines[count.index].suffix}" # Enhanced naming convention with optional suffix
  path         = "\\${var.pipelines[count.index].owning_team}\\${var.pipelines[count.index].name_prefix}"  # Grouping pipelines into folders

  repository {
    repo_type   = "TfsGit"
    repo_id     = var.repository_id
    branch_name = var.pipelines[count.index].branch
    yaml_path   = var.pipelines[count.index].yaml_path
  }
}
