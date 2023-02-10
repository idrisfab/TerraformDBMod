/*

  resource  "aws_db_instance" "db" {


  identifier = "mydb"

    allocated_storage    = 10
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t2.micro"
    db_name                 = "mydb"
    username             = "nathan"
    password             = "password"
    port     = "3306"
    parameter_group_name = "default.mysql5.7"
    skip_final_snapshot  = true
    

    iam_database_authentication_enabled = false

    db_subnet_group_name = var.my_private_subnet_group

    vpc_security_group_ids = [var.my_security_group]

    tags = {
      Name = "default"
    }

  }
*/

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_database_cluster" "db" {
  name              = "example-cluster"
  engine            = "mariadb"
  version           = "10.3"
  size              = "db-s-1vcpu-1gb"
  region            = "nyc1"
  private_network_uuid = digitalocean_vpc.example.id
  maintenance_window_start = "17:00:00"
  maintenance_window_day = "sun"
}

output "cluster_connection_string" {
  value = digitalocean_database_cluster.example.connection_string
}

provider "local" {
  command = "bash"
}

locals {
  database_name     = "example_database"
  database_username = "example_user"
  database_password = "example_password"
}

provisioner "local-exec" {
  command = <<EOF
    mysql -h ${digitalocean_database_cluster.example.host} -u ${digitalocean_database_cluster.example.private_network_uuid} -p${digitalocean_database_cluster.example.private_network_uuid} -e "CREATE DATABASE ${local.database_name};"
    mysql -h ${digitalocean_database_cluster.example.host} -u ${digitalocean_database_cluster.example.private_network_uuid} -p${digitalocean_database_cluster.example.private_network_uuid} -e "GRANT ALL PRIVILEGES ON ${local.database_name}.* TO '${local.database_username}'@'%' IDENTIFIED BY '${local.database_password}';"
    mysql -h ${digitalocean_database_cluster.example.host} -u ${digitalocean_database_cluster.example.private_network_uuid} -p${digitalocean_database_cluster.example.private_network_uuid} -e "FLUSH PRIVILEGES;"
EOF
}


 
 
