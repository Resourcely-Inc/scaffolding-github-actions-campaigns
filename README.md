# Resourcely Github Actions Campaigns Scaffolding

## Overview

This repository provides a scaffolding to help you start using Resourcely campaigns. It sets up the necessary framework to integrate Resourcely into a repository that uses GitHub Actions with multi-environment as the Terraform runner.

It contains a [workflow](.github/workflows/terraform.yml) that runs `terraform plan` and then uses the [Resourcely GitHub Action](https://github.com/Resourcely-Inc/resourcely-action) to evaluate guardrails on that plan.

## Configuration

### `.resourcely.yaml` Setup

For all environments configured with the campaigns-agent, you must ensure that the source for the state file is associated with the config root in `.resourcely.yaml`.

For a config root to be configured for campaigns, it requires the following block:

```yaml
version: "2"
terraform_config_roots:
  - name: basic
    default_file: main.tf
    path: .
    skip: false
    campaign_config:
      state_file_config:
        s3:
          path: s3://campaigns-terraform-state/terraform.tfstate
```

### IAM Roles for GitHub Actions

To securely connect GitHub Actions to AWS, use IAM roles as described in [this AWS blog post](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/).

## Assumptions

- Uses GitHub Actions to run `terraform plan` and `terraform apply`.


## File Structure

- `main.tf`: Defines Terraform resources.
- `provider.tf`: Configures Terraform providers.
- `terraform.tf`: Specifies required providers and global settings.
- `vars.tf`: Declares variables used in Terraform configurations.
- `dev.tfvars` / `prod.tfvars`: Environment-specific Terraform variables.
- `.resourcely.yaml`: Configures Resourcely’s Terraform integration. [Learn more](https://docs.resourcely.io/getting-started/onboarding/configuring-resourcely.yaml#what-is-.resourcely.yaml).

## Environments

This scaffolding supports multiple environments using a single config root and `*.tfvars` per environment. More details can be found in the [Resourcely.yaml Structure documentation](https://docs.resourcely.io/getting-started/onboarding/configuring-resourcely.yaml#resourcely.yaml-structure).

When creating a Pull Request and selecting the config root (e.g., `Resourcely Demo` specified in `.resourcely.yaml`), Resourcely will detect and reference those environments in the form. If creating a pull request from a blueprint, you can toggle the "Env" setting and select the `versioning_configuration_status` variable to reference values from `dev.tfvars` and `prod.tfvars`.

## Setup Guide

### Configure Terraform Backend

Terraform state must be stored in a durable backend. Learn more about [Terraform backends](https://developer.hashicorp.com/terraform/language/settings/backends/configuration).

Edit [terraform.tf](terraform.tf) to configure your backend.

### Add Resourcely API Token to GitHub Secrets

- Generate a new API token in the [Resourcely portal](https://portal.resourcely.io/settings/generate-api-token).
- Create a [GitHub repository secret](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository) named `RESOURCELY_API_TOKEN`.

### Update `.resourcely.yaml`

Ensure `.resourcely.yaml` correctly reflects the location of Terraform configurations.

### Validate Manifest Configuration

Verify that your GitHub Actions workflow contains a valid manifest configuration. View the [manifest file](https://github.com/Resourcely-Inc/scaffolding-github-actions/blob/main/.github/workflows/terraform.yml#L89-L101).
