module "service" {
  source = "git::https://github.com/maison-douce-bakery/platform-terraform-modules.git//modules/ecs-service?ref=ecs-service/v0.3.0"

  name         = local.name
  cluster_name = data.aws_ecs_cluster.this.cluster_name
  vpc_id       = data.aws_vpc.this.id
  subnet_ids   = data.aws_subnets.public.ids

  image = local.image
  # No NAT: the public IP is the task's way out to ECR and AWS APIs. The task SG allows no inbound.
  assign_public_ip = true

  # One Python loop with a 60-second sleep, plus the Postgres client's connection pool.
  cpu    = 256
  memory = 512

  environment = {
    PGHOST     = data.aws_db_instance.this.address
    PGPORT     = tostring(data.aws_db_instance.this.port)
    PGDATABASE = "bakery"
    PGUSER     = "commerce"
    PGSSLMODE  = "require"
  }

  secrets = {
    PGPASSWORD = { secret_arn = data.aws_secretsmanager_secret.db.arn, json_key = "password" }
  }
  secrets_kms_key_arns = [data.aws_kms_alias.db.target_key_arn]

  permissions_boundary_arn = data.aws_iam_policy.boundary.arn
}

# Lets the service connect to RDS. Can't be in the module's `depends_on`: it needs the module's
# security group, which would be a cycle.
resource "aws_vpc_security_group_ingress_rule" "rds_from_service" {
  security_group_id            = data.aws_security_group.rds.id
  referenced_security_group_id = module.service.security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  description                  = local.name
}
