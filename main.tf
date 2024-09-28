provider "aws" {
  region = var.aws_region 
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "my_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zones[count.index]
}

resource "aws_subnet" "my_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "aurora_sg" {
  name   = "aurora_sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir acesso de qualquer IP.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_subnet_group" "aurora_subnet_group" {
  name       = "aurora_subnet_group"
  subnet_ids = [aws_subnet.my_subnet_1.id, aws_subnet.my_subnet_2.id]
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "my-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "13.6"
  database_name           = "mydb"
  master_username         = "admin"
  master_password         = "password123"
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_rds_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]

  availability_zones = ["us-east-1a", "us-east-1b"]

  storage_encrypted = true
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = 1  # Número de instâncias no cluster
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = "db.m6g.large"  # 2 vCPUs, 8 GB RAM
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible = false
}







