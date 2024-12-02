output "db_endpoint" {
  value = aws_rds_cluster.meu_banco_de_dados.endpoint
}

output "db_port" {
  value = aws_rds_cluster.meu_banco_de_dados.port
}

output "db_name" {
  value = aws_rds_cluster.meu_banco_de_dados.database_name
}

output "db_username" {
  value = aws_rds_cluster.meu_banco_de_dados.master_username
}
