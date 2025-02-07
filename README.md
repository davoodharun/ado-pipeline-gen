# Azure DevOps Pipeline Configuration Manager

This repository contains an Azure DevOps pipeline that automates the management of pipeline configurations across multiple repositories.

## Overview

The pipeline performs the following tasks:

1. Scans through a provided list of repositories
2. For each repository, downloads the `.azuredevops/pipelines.json` configuration file
3. Uses the downloaded configurations as input variables for a Terraform project that manages Azure DevOps pipeline definitions

## Configuration Structure

### Repository Configuration File
Each repository should contain a configuration file at `.azuredevops/pipelines.json` that defines the pipeline settings. The configuration should match the following structure:

```json
{
  "pipelines": [
    {
      "name": "pipeline-name",  
      "owning_team": "team-name",
      "branch": "main",
      "yaml_path": "path/to/azure-pipelines.yml"
    }
  ]
}   
```

### Terraform Project
The Terraform project is used to manage the Azure DevOps pipeline definitions. The project should contain the following files:  

``` terraform                                                                                               








