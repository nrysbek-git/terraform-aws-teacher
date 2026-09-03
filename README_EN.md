# Terraform AWS Foundations Lab

[Русский](README.md) | [English](README_EN.md)

This instructor reference provisions a three-tier AWS environment: public
subnets for an ALB and NAT Gateway, private subnets for two Nginx EC2 instances,
and isolated subnets for PostgreSQL RDS. Systems Manager provides administration
without SSH, CloudWatch monitors CPU, and RDS manages its password in Secrets
Manager.

> NAT Gateway, ALB, two EC2 instances, and RDS incur hourly charges. Review
> current pricing before applying and destroy the workload immediately after the
> demonstration.

## Course position

Use this lab after Terraform and AWS fundamentals and before the Kubernetes Todo
Lab and CloudOps Capstone. Expected completion time is one to two weeks.

## Repository layout

- `bootstrap/` creates the protected S3 remote-state bucket;
- `modules/network/` is a reusable network module;
- `modules/web-server/` creates EC2, its Security Group, and Nginx;
- `modules/database/` creates private RDS and database network controls;
- `environments/dev/` composes the modules;
- `.github/workflows/terraform.yml` runs formatting and validation checks.

See [TERRAFORM_CONCEPTS.md](TERRAFORM_CONCEPTS.md) for the root/child module
flow and the roles of variables, locals, data sources, resources, and outputs.

## Requirements and deployment

Install Terraform 1.10+, AWS CLI v2, and Git. Terraform 1.10+ is required for
native S3 state locking. Authenticate to a training AWS
account and verify it with `aws sts get-caller-identity`.

```bash
cd bootstrap
terraform init
terraform apply
terraform output state_bucket_name

cd ../environments/dev
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars
# Put the bucket output into backend.hcl.
terraform init -backend-config=backend.hcl
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
terraform output website_url
```

Open `website_url` in a browser. SSH is intentionally closed, and the instance
requires IMDSv2. With the Session Manager plugin installed, connect using:

```bash
aws ssm start-session --target "$(terraform output -json instance_ids | jq -r '.[0]')"
```

## Cleanup

Run `terraform destroy` from `environments/dev` immediately after assessment to
avoid unnecessary charges. The state bucket has `prevent_destroy`; remove it
only as a deliberate final cleanup step after preserving or deleting its state.

Students receive the separate `terraform-aws-starter` repository. Do not expose
this reference solution before submission.
