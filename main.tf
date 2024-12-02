provider "aws" {
  region = var.aws_region 
}

terraform {
  backend "s3" {}
}

resource "aws_security_group" "aurora_sg" {
  name        = "db_security_group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "meu_banco_de_dados" {
  cluster_identifier      = "meu-cluster-aurora" 
  engine                  = "aurora-postgresql"
  engine_mode             = "serverless"
  database_name           = "tech_challenge_dev"
  master_username         = "postgres"
  master_password         = var.db_password 
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  skip_final_snapshot     = true

  scaling_configuration {
    auto_pause               = true
    max_capacity             = 64
    min_capacity             = 2
    seconds_until_auto_pause = 300
  }
}
