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


resource "aws_instance" "Artifactory-Ubuntu" {
  ami           = "ami-cbfcd2b8"
  instance_type = "t2.micro"
  key_name = "${var.keyname}"
  tags {
	Name = "${var.servername}"
  }
  vpc_security_group_ids = "${var.secgroups}"
  provisioner "remote-exec" {
    inline = [
	  "sudo bash -c \"echo 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/' >> /etc/environment\"",
	  "cd /home/ubuntu",
      "echo \"deb https://bintray.com/artifact/download/jfrog/artifactory-debs yakkety main\" | sudo tee -a /etc/apt/sources.list.d/artifactory-oss.list",
      "curl https://bintray.com/user/downloadSubjectPublicKey?username=jfrog | sudo apt-key add -",
	  "sudo apt-get update",
	  "sudo apt-get install jfrog-artifactory-pro"
]
    connection {
      type = "ssh"
	  user = "ubuntu"
	  agent = "false"
	  private_key = "${file("../../../Keys/HomeBase.pem")}"
    }
  }
}
