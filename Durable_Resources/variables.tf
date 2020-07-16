variable "region" {
    default = "us-east-1"
}

variable "vpc_cidr" {
 default = "172.31.0.0/16"
 description = "the vpc cdir"
}

variable "subnets_cidr" {
    type = list(string)
    default = ["172.31.0.0/20", "172.31.64.0/20"]
}

variable "azs" {
    type = list(string)
    default = ["us-east-1a", "us-east-1b"]
}

variable "webservers_ami" {
  description = "Ubuntu Server 16.04 LTS (HVM)"
  default = "ami-059eeca93cf09eebd"
#     description = "Linux for apache"
#     default = "ami-0ff8a91507f77f867"
}

variable "domain" {
    default = "*.avioranalytics.net"
}

variable "instance_type" {
    # default = "t2.nano"
    default = "t2.micro"
}