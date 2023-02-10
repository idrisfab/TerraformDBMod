/*
    output "db_endpoint" {
        value = aws_db_instance.db.endpoint
    }

    output "username" {
        value = aws_db_instance.db.username
    }

    output "password" {
        value = nonsensitive(aws_db_instance.db.password)
    }            


    output "db_name" {
        value = aws_db_instance.db.db_name
    }
*/

output "cluster_connection_string" {
  value = digitalocean_database_cluster.example.connection_string
}

output "instance_name" {
    value = digitalocean_database_cluster.db.urn
}