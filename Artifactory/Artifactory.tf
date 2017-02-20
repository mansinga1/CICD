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


resource "aws_instance" "Artifactory" {
  ami           = "ami-02ace471"
  instance_type = "t2.micro"
  key_name = "${var.keyname}"
  tags {
	Name = "${var.servername}"
  }
  vpc_security_group_ids = "${var.secgroups}"
  provisioner "remote-exec" {
    inline = [
	  "sudo yum install wget -y",
	  "wget --no-cookies --no-check-certificate --header \"Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie\" \"http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz\"",
	  "sudo mkdir /opt/jdk1.8.0_121",
	  "sudo tar xzf jdk-8u121-linux-x64.tar.gz -C /opt",
	  "cd /opt/jdk1.8.0_121/",
	  "sudo alternatives --install /usr/bin/java java /opt/jdk1.8.0_121/bin/java 2",
	  "sudo alternatives --set java /opt/jdk1.8.0_121/bin/java",
	  "sudo alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_121/bin/jar 2",
	  "sudo alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_121/bin/javac 2",
	  "sudo alternatives --set jar /opt/jdk1.8.0_121/bin/jar",
	  "sudo alternatives --set javac /opt/jdk1.8.0_121/bin/javac",
	  "sudo bash -c \"echo 'export JAVA_HOME=/opt/jdk1.8.0_121' >> /etc/bashrc\"",
	  "sudo bash -c \"echo 'export JRE_HOME=/opt/jdk1.8.0_121/jre' >> /etc/bashrc\"",
	  "sudo bash -c \"echo 'export PATH=$PATH:/opt/jdk1.8.0_121/bin:/opt/jdk1.8.0_121/jre/bin' >> /etc/bashrc\"",
	  "cd /home/ec2-user",
      "wget https://bintray.com/jfrog/artifactory-pro-rpms/rpm -O bintray-jfrog-artifactory-pro-rpms.repo",
      "sudo mv bintray-jfrog-artifactory-pro-rpms.repo /etc/yum.repos.d/",
      "sudo yum -y install jfrog-artifactory-pro",
	  "sudo -E service artifactory start"
]
    connection {
      type = "ssh"
	  user = "ec2-user"
	  agent = "false"
	  private_key = "${file("../../../Keys/HomeBase.pem")}"
    }
  }
}
