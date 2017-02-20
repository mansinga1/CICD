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


resource "aws_instance" "Jenkins" {
  ami           = "ami-cbfcd2b8"
  instance_type = "t2.micro"
  key_name = "${var.keyname}"
  tags {
	Name = "${var.servername}"
  }
  vpc_security_group_ids = "${var.secgroups}"
  provisioner "remote-exec" {
    inline = [
      "wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt-get update",
      "sudo apt-get -y install jenkins"
    ]
    connection {
      type = "ssh"
	  user = "ubuntu"
	  agent = "false"
	  private_key = "${file("../../Keys/HomeBase.pem")}"
    }
  }
}
