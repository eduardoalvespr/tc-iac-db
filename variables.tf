variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = ["172.31.0.0/16"]
}

variable "db_password" {
  type      = string
  sensitive = true
  description = "Senha do usuário mestre do banco de dados Aurora"
}

variable "vpc_id" {
  default = "vpc-01bb5dee3529552cf"
}
