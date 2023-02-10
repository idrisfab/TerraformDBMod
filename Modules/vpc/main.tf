/**

resource "digitalocean_vpc" "example_vpc" {
  name = "example-vpc"
  cidr = "10.0.0.0/16"
}

resource "digitalocean_network" "example_network" {
  name    = "example-network"
  vpc_id  = digitalocean_vpc.example_vpc.id
  cidr    = "10.0.0.0/24"
}

# Create an igw
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    Name = "${var.name}.igw"
  }
}

# Create public sub
resource "aws_subnet" "subpublic" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = var.cidrsubpub1
  availability_zone = var.AZa
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}.subpublic"
  }
}

# Create private sub
resource "aws_subnet" "subprivate1" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = var.cidrsubpr1
  availability_zone = var.AZb
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name}.subprivate1"
  }
}

# Create private sub
resource "aws_subnet" "subprivate2" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = var.cidrsubpr2
  availability_zone = var.AZc
  map_public_ip_on_launch = false 

  tags = {
    Name = "${var.name}.subprivate2"
  }
}

# Creating a public route table
resource "aws_route_table" "routepublic" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = var.opencidr
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.name}.route.public"
  }
}

# Creating a private route table
resource "aws_route_table" "routeprivate1" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    Name = "${var.name}.route.private"
  }
}

resource "aws_route_table" "routeprivate2" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    Name = "${var.name}.route.private"
  }
}

# Route table associations
resource "aws_route_table_association" "routeapp" {
  subnet_id = aws_subnet.subpublic.id
  route_table_id = aws_route_table.routepublic.id
}

resource "aws_route_table_association" "routedb1" {
  subnet_id = aws_subnet.subprivate1.id
  route_table_id = aws_route_table.routeprivate1.id
}

resource "aws_route_table_association" "routedb2" {
  subnet_id = aws_subnet.subprivate2.id
  route_table_id = aws_route_table.routeprivate2.id
}

# Creating security group for webapp
resource "aws_security_group" "sgapp" {
  name        = var.appsg
  description = var.appsgdesc
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
   description = var.httpx
   from_port = 443 
   to_port = 443 
   protocol = var.tcp 
   cidr_blocks = [var.opencidr] 
  }

  ingress {
   description = var.httpx
   from_port = 80 
   to_port = 80 
   protocol = var.tcp
   cidr_blocks = [var.opencidr]
  }

  ingress {
   description = var.ssh
   from_port = 22
   to_port = 22
   protocol = var.tcp
   cidr_blocks = [var.opencidr]
    
  }

  ingress {
   description = "dev"
   from_port = 5000
   to_port = 5000
   protocol = "tcp"
   cidr_blocks = [var.opencidr]
    
  }

  egress {
   to_port = 0 
   from_port = 0
   protocol = -1 
   cidr_blocks = [var.opencidr]
  }

  tags = {
    Name = "${var.name}sg.app"
  }
}

resource "aws_security_group" "sgdb" {
  name        = var.dbsg
  description = var.dbsgdesc
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
   description = var.httpx
   from_port = 3306
   to_port = 3306
   protocol = var.tcp
   security_groups = [aws_security_group.sgapp.id]
  }

  egress {
   to_port = 0 
   from_port = 0
   protocol = -1 
   cidr_blocks = [var.opencidr]
  }
}

resource "aws_db_subnet_group" "maindba" {
  name       = "maindba"
  subnet_ids = [aws_subnet.subprivate1.id, aws_subnet.subprivate2.id] #"${aws_subnet.subprivate2.id}"]

  tags = {
    Name = "My DB subnet group"
  }   
 }

 */


provider "digitalocean" {
  version = "2.0"
}

resource "digitalocean_vpc" "example_vpc" {
  name = "example-vpc"
  cidr = "10.0.0.0/16"

}

resource "digitalocean_network" "public_network_1" {
  name = "private-network-1"
  vpc_id = digitalocean_vpc.example_vpc.id
  ip_version = "ipv4"
  cidr    = "10.0.1.0/24"

}

resource "digitalocean_network" "private_network_1" {
  name = "private-network-1"
  vpc_id = digitalocean_vpc.example_vpc.id
  ip_version = "ipv4"
  cidr    = "10.0.2.0/24"

}

resource "digitalocean_network" "private_network_2" {
  name = "private-network-2"
  vpc_id = digitalocean_vpc.example_vpc.id
  ip_version = "ipv4"
  cidr    = "10.0.3.0/24"
}

resource "digitalocean_internet_gateway" "example_internet_gateway" {
  name = "example-internet-gateway"
  vpc_id = digitalocean_vpc.example_vpc.id
}

resource "digitalocean_route_table" "example_public_route_table" {
  name = "example-public-route-table"
  vpc_id = digitalocean_vpc.example_vpc.id

  routes = [
    {
      destination_network = "10.0.1.0/24"
      gateway_id = digitalocean_internet_gateway.example_internet_gateway.id
    },
  ]
}

resource "digitalocean_route_table" "example_private_route_table" {
  name = "example-private-route-table"
  vpc_id = digitalocean_vpc.example_vpc.id
  routes = [
    {
      destination_networks = ["10.0.2.0/24", "10.0.3.0/24"]
          },
  ]
}

resource "digitalocean_firewall" "web_firewall" {
  name        = "web-firewall"
  vpc_id      = digitalocean_vpc.example_vpc.id
  inbound_rule = [
    {
      protocol = "tcp"
      port_range = "80"
      source_addresses = ["0.0.0.0/0"]
    },
    {
      protocol = "tcp"
      port_range = "443"
      source_addresses = ["0.0.0.0/0"]
    },
    {
      protocol = "tcp"
      port_range = "5000"
      source_addresses = ["0.0.0.0/0"]
    },
    {
    protocol = "tcp"
      port_range = "22"
      source_addresses = ["0.0.0.0/0"]
    },
  ]
}

resource "digitalocean_db_subnet_group" "example_db_subnet_group" {
  name = "example-db-subnet-group"

  subnet_ids = [
    digitalocean_network.private_network_1.id,
    digitalocean_network.private_network_2.id,
  ]

  ingress_rules = [
    {
      security_group_id = digitalocean_firewall.web_firewall.id
    },
  ]
}

