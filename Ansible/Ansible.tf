variable "acckey" {type = "string"}
variable "seckey" {type = "string"}
variable "secgroups" {type = "list"}
variable "servername" {type = "string"}
variable "keyname" {type = "string"}

provider "aws" {
  access_key = "${var.acckey}"
  secret_key = "${var.seckey}"
  region     = "eu-west-1"
}


resource "aws_instance" "Ansible" {
  ami           = "ami-b11540c2"
  instance_type = "t2.micro"
  key_name = "${var.keyname}"
  tags {
	Name = "${var.servername}"
  }
  vpc_security_group_ids = "${var.secgroups}"
}
