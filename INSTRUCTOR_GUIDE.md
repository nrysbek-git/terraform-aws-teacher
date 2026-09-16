# Руководство преподавателя / Instructor guide

## Назначение teacher repository

Это эталонная реализация, по которой преподаватель заранее проверяет lab,
демонстрирует безопасный Terraform workflow и оценивает student submissions.
Teacher repository не выдаётся студентам до защиты.

## Нужно ли преподавателю запускать plan и apply?

Да, но это два разных контрольных этапа:

1. `terraform plan` обязателен до занятия: он проверяет dependency graph,
   доступность provider data и фактический набор изменений.
2. `terraform apply` выполняется только в отдельном учебном AWS account после
   cost review. Он нужен хотя бы один раз, чтобы проверить ALB health, EC2
   bootstrap, SSM и RDS, которые нельзя доказать одним `validate`.
3. После проверки выполняется `terraform destroy`; S3 state bucket удаляется
   отдельно и только по утверждённой процедуре.

Нельзя запускать `apply`, если identity/region неверны, plan содержит неожиданные
ресурсы или преподаватель не готов сразу выполнить cleanup.

## Предварительный контроль

```bash
aws sts get-caller-identity
terraform version
terraform fmt -check -recursive
```

Проверьте AWS account ID, разрешённый region, budgets/alerts и отсутствие
credentials, state, `backend.hcl`, `terraform.tfvars` и plan files в Git.

## Bootstrap state

```bash
cd bootstrap
terraform init
terraform validate
terraform plan -out=bootstrap.tfplan
terraform show bootstrap.tfplan
terraform apply bootstrap.tfplan
terraform output state_bucket_name
```

Затем создайте ignored `environments/dev/backend.hcl` из example и вставьте
фактическое имя bucket.

## Основной plan и review gate

```bash
cd ../environments/dev
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars
terraform init -backend-config=backend.hcl
terraform validate
terraform plan -out=tfplan
terraform show tfplan
```

До apply подтвердите:

- public access принимает только ALB на port 80;
- EC2 находятся в private subnets без public IP и без SSH;
- database subnets не имеют default internet route;
- RDS private/encrypted и принимает 5432 только от application SG;
- secret value отсутствует в variables и outputs;
- план содержит ожидаемые NAT Gateway, ALB, две EC2 и RDS;
- `enable_billable_resources=true` установлен осознанно.

## Controlled apply и проверка

```bash
terraform apply tfplan
terraform output
curl "$(terraform output -raw website_url)"
```

Проверьте HTTP 200, две healthy targets, SSM managed nodes, CloudWatch alarm и
private RDS endpoint. Повторный `terraform plan` должен вернуть `No changes`.

## Cleanup gate

```bash
terraform plan -destroy -out=destroy.tfplan
terraform show destroy.tfplan
terraform apply destroy.tfplan
```

После этого подтвердите отсутствие EC2, ALB, NAT Gateway и RDS. Не удаляйте S3
state bucket автоматически: у него включён `prevent_destroy`, а versioned state
может требоваться для аудита или следующего занятия.

## English summary

The instructor must run and review a saved plan. Apply once in an isolated
training account to verify runtime behavior, only after account, region, cost,
and security checks. Verify HTTP/target health/SSM/RDS, confirm a second plan is
idempotent, and destroy billable workload immediately after the demonstration.
