# Terraform concepts used in this project

## Root module

`environments/dev` is the root module. It is the entry point from which the
operator runs `terraform init`, `plan`, `apply`, and `destroy`. It configures the
provider, backend, environment variables, common tags, and child modules.

## Child modules

- `modules/network` owns VPC, subnets, routing, and the Internet Gateway.
- `modules/web-server` owns the Security Group, EC2 instance, AMI lookup, and
  bootstrap script.

The root passes input variables into each child. Child modules return values via
outputs. The web-server module receives `vpc_id` and `subnet_id` from the network
module, so Terraform automatically creates the correct dependency graph.

## Variables, locals, data sources, resources, and outputs

| Construct | Purpose | Project example |
|---|---|---|
| `variable` | Input supplied by a caller | region, CIDR, instance type |
| `local` | Named computed value inside a module | resource name, common tags, subnet map |
| `data` | Read existing provider information | AWS account, region, AZs, AMI, IAM policy document |
| `resource` | Create or manage infrastructure | VPC, EC2, IAM role, CloudWatch alarm, S3 bucket |
| `output` | Return a useful module or root value | website URL, VPC ID, subnet map |

Inspect calculated values before apply:

```bash
terraform console
> local.name
> local.selected_availability_zones
> module.network.public_subnet_ids
```

After apply:

```bash
terraform output
terraform output -json
terraform graph
```

Do not output secrets. Mark an unavoidable secret output as `sensitive = true`,
but remember that sensitive values still exist in Terraform state.
