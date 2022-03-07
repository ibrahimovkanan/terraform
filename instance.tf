provider "aws" {
   region = "us-east-1"
}

terraform {
   backend "s3" {
      bucket = "terraformbucket31"  
      key    = "gitaction/terraform.tfstate"
      region = "us-east-1"
   }
}



resource "aws_instance" "database" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  key_name = "faridkey"

  connection {
    type     = "ssh"
    host     = self.public_ip
    user     = "ubuntu"
    private_key = file("/home/farid/Downloads/faridkey.pem")
  }


   provisioner "file" {
    source      = "user.sql"
    destination = "/home/ubuntu/user.sql"
  
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install mysql-server -y",
      "sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf ",
      "sudo service mysql restart",
      "sudo mysql < user.sql"
    ]
  }
}


resource "aws_instance" "app" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  key_name = "faridkey"


  connection {
    type     = "ssh"
    host     = self.public_ip
    user     = "ubuntu"
    private_key = file("/home/farid/Downloads/faridkey.pem")
  }


  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt upgrade -y",
      "sudo apt install default-jre -y",
      "sudo apt install maven -y",
      "git clone https://github.com/Farid987/spring-petclinic.git",
      "cd spring-petclinic",
      "sed -i 's/0.0.0.0/${aws_instance.database.private_ip}/g' src/main/resources/application-mysql.properties"
    ]
  }

}


output "ip" {
  value = aws_instance.app.public_ip
}


 





