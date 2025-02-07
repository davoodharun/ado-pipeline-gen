# Azure DevOps Pipeline Provisioner

This project automates the creation of Azure DevOps pipelines using Terraform. It's designed to provision pipelines that use GitHub repositories as their source.

## Overview

The system consists of several components that work together:

1. A top-level Azure DevOps pipeline (`azure-pipelines.yaml`) that orchestrates the process
2. A template pipeline (`create-pipelines.yaml`) that defines the provisioning steps
3. A Node.js script (`get-pipeline-config.js`) that fetches pipeline configurations
4. Terraform configurations (`main.tf`) that create the actual pipelines

## How It Works

1. The process starts when you run the top-level pipeline, providing:
   - `repository_name`: The GitHub repository name
   - `project_name`: The Azure DevOps project name (defaults to EU-Services)

2. The pipeline uses a template that:
   - Sets up Node.js and Terraform environments
   - Downloads pipeline configurations from the source repository
   - Initializes Terraform with Azure backend storage
   - Applies the Terraform configuration to create pipelines

3. The Node.js script:
   - Connects to Azure DevOps API
   - Downloads pipeline configuration from `.azuredevops/pipelines.json` in the source repository
   - Saves it locally for Terraform to use

4. Terraform:
   - Uses the Azure DevOps provider to create pipelines
   - References the GitHub service connection
   - Creates pipelines with standardized naming and folder structure

## File Structure

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
                                                                                      








