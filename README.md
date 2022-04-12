
## Sentry Installation

Based on https://develop.sentry.dev/self-hosted/#getting-started

Created stack in AWS using Terraform

### Deployment

To deploy this project, configure AWS Access Key and Secret on your local machine 

```bash
export AWS_ACCESS_KEY_ID="<YOUR_AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<YOUR_AWS_SECRET_ACCESS_KEY>"
export AWS_DEFAULT_REGION="<YOUR_AWS_DEFAULT_REGION>"
```

Install Terraform as described here
https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started

1. Clone the repo
2. Update `environment.auto.tfvars` with the required values depending on your environment.  You will need to create a AWS certificate within AWS and use the `arn` here
3. Run `terraform plan` to validate the changes which are going to be made
4. Run `terraform apply` to apply the changes
5. Run `terraform destroy` to tear down the resources created