# Terraform AWS Foundations Lab

[Русский](README.md) | [English](README_EN.md)

Эталонный проект преподавателя для практики Infrastructure as Code. Terraform
создаёт трёхуровневую AWS-инфраструктуру: public subnets для ALB и NAT Gateway,
private subnets для двух EC2 с Nginx и isolated subnets для PostgreSQL RDS. IAM
instance profile даёт доступ через Systems Manager без SSH, CloudWatch следит за
CPU, а пароль RDS управляется AWS Secrets Manager.

> Этот вариант создаёт NAT Gateway, ALB, две EC2 и RDS, которые оплачиваются
> почасово. Перед `apply` изучите стоимость, а после демонстрации сразу выполните
> `terraform destroy`.

## Место в учебной программе

Проект выполняется после основ Terraform и AWS, перед Kubernetes Todo и BookingKG
Capstone. Ожидаемая продолжительность — 1–2 недели.

```mermaid
flowchart LR
  STUDENT[Student] --> TF[Terraform CLI]
  TF --> S3[(S3 remote state)]
  TF --> VPC[AWS VPC]
  VPC --> IGW[Internet Gateway]
  VPC --> PUB[Public subnets x2]
  VPC --> APP[Private app subnets x2]
  VPC --> DBNET[Isolated DB subnets x2]
  PUB --> NAT[NAT Gateway]
  PUB --> ALB[Application Load Balancer]
  USER[Browser] -->|HTTP 80| ALB
  ALB --> EC2[EC2 + Nginx x2]
  APP --> EC2
  EC2 -->|outbound| NAT
  SSM[AWS Systems Manager] -->|IAM role, no SSH| EC2
  EC2 --> CW[CloudWatch CPU alarm]
  EC2 -->|PostgreSQL 5432| RDS[(Private RDS PostgreSQL)]
  DBNET --> RDS
  RDS --> SM[AWS Secrets Manager]
```

## Структура

- `bootstrap/` — отдельный state для создания защищённого S3 backend;
- `modules/network/` — reusable network module;
- `modules/web-server/` — EC2, Security Group и Nginx;
- `modules/database/` — private RDS, DB subnet group и database Security Group;
- `environments/dev/` — composition root среды dev;
- `.github/workflows/terraform.yml` — fmt и validate без AWS credentials.

Объяснение `root module`, `child modules`, `variables`, `locals`, `data sources`
и `outputs`: [TERRAFORM_CONCEPTS.md](TERRAFORM_CONCEPTS.md).

## Предварительные требования

- Terraform 1.10+ (для native S3 state locking);
- AWS CLI v2;
- учебный AWS account и настроенная аутентификация;
- Git.

Проверьте identity перед созданием ресурсов:

```bash
aws sts get-caller-identity
terraform version
```

## Запуск

Сначала создайте S3 bucket для state:

```bash
cd bootstrap
terraform init
terraform apply
terraform output state_bucket_name
```

Скопируйте `environments/dev/backend.hcl.example` в `backend.hcl`, замените имя
bucket результатом output и выполните:

```bash
cd ../environments/dev
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars
terraform init -backend-config=backend.hcl
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
terraform output website_url
```

Откройте `website_url` в браузере. SSH специально не открыт: Nginx устанавливается
через `user_data`, EC2 требует IMDSv2, а административный доступ выполняется
через AWS Systems Manager Session Manager:

```bash
aws ssm start-session --target "$(terraform output -json instance_ids | jq -r '.[0]')"
```

`instance_ids` является списком. Пароль базы не выводится: используйте ARN из
`database_master_secret_arn` только при наличии разрешения на Secrets Manager.

## Cleanup

Сначала удалите workload, затем при необходимости state bucket. У bucket включён
`prevent_destroy`, поэтому удалять его следует только осознанно после удаления
state versions.

```bash
cd environments/dev
terraform destroy
```

## Для преподавателя

Студентам выдаётся отдельный репозиторий `terraform-aws-starter`. Это repository
содержит эталонную реализацию и не должен открываться студентам до защиты.
