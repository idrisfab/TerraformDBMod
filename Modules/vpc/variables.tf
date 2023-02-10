variable "name" {
 type = string
 default= "Nathan.F_Idris.F"
}

variable  "vpccidr" {
 type = string
 default = "10.0.0.0/16"
}

variable  "cidrsubpub1" {
 type = string
 default = "10.0.1.0/24"
}

variable  "cidrsubpr1" {
 type = string
 default = "10.0.2.0/24"
}

variable  "cidrsubpr2" {
 type = string
 default = "10.0.3.0/24"
}

variable  "AZa" {
 type = string
 default = "lon1"
}

variable  "AZb" {
 type = string
 default = "eu-west-2b"
}

variable  "AZc" {
 type = string
 default = "eu-west-2c"
}

variable  "opencidr" {
 type = string
 default = "0.0.0.0/0"
}

variable  "appsg" {
 type = string
 default = "app-sg123"
}

variable  "dbsg" {
 type = string
 default = "db-sg123"
}

variable  "appsgdesc" {
 type = string
 default = "http and https access"
}

variable  "dbsgdesc" {
 type = string
 default = "EC2 access only"
}

variable  "tcp" {
 type = string
 default = "tcp"
}

variable  "ssh" {
 type = string
 default = "ssh"
}

variable "httpx" {
  type = string
  default = "http and https"
}


