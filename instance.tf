
resource "aws_instance" "database" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  security_groups= ["${aws_security_group.test.id}"]
  key_name = "mytestkey"
  subnet_id = "${aws_subnet.subnet2.id}"

  connection {
    type     = "ssh"
    host     = self.public_ip
    user     = "ubuntu"
    private_key = file("mytestkey.pem")
  }


   provisioner "file" {
    source      = "user.sql"
    destination = "/home/ubuntu/user.sql"
  
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt update -y",
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
  security_groups= ["${aws_security_group.test.id}"]
  key_name = "mytestkey"
  subnet_id = "${aws_subnet.subnet1.id}"


  connection {
    type     = "ssh"
    host     = self.public_ip
    user     = "ubuntu"
    private_key = file("mytestkey.pem")
  }


  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt upgrade -y",
      "sudo apt install default-jre -y",
      "sudo apt install maven -y",
      "git clone https://github.com/Farid987/spring-petclinic.git",
      "cd spring-petclinic",
      "sed -i 's/0.0.0.0/${aws_instance.database.private_ip}/g' src/main/resources/application-mysql.properties",
      "mvn spring-boot:run -Dspring-boot.run.profiles=mysql"
    ]
  }

}

output "ip" {
  value = aws_instance.app.public_ip
} 





