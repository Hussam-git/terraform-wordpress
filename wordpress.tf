provider "aws" {
    region = "ap-south-1"
    profile = "hussam"
}

resource "aws_instance" "wp" {
    ami = "ami-06a0b4e3b7eb7a300"
    key_name = "project"
    instance_type = "t2.micro"


    tags = {
        Name = "Wordpress_db_task"
          }





    

connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("C:/Users/hussa/Downloads/project.pem")
    host = aws_instance.wp.public_ip   
    }


provisioner "remote-exec" {
    inline = [
        "sudo yum install httpd php php-mysqlnd php-json wget -y", 
        "sudo wget https://wordpress.org/latest.tar.gz",
        "tar -xzvf latest.tar.gz",
        "sudo mv wordpress/* /var/www/html/",
        "sudo chown -R apache.apache /var/www/html",
        "sudo setenforce 0",
        "sudo systemctl start httpd"
           ]
       }
}


output "wp_public_ip" {
    value = aws_instance.wp.public_ip
}

resource "aws_db_instance" "wp_db" {
  depends_on = [
    aws_instance.wp
  ]
  allocated_storage    = 10
  identifier = "wordpress-database"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "wordpress"
  username             = "abc"
  password             = "Hussam@123"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible = true
  skip_final_snapshot  = true
}


output "Endpoint_string" {
  value = aws_db_instance.wp_db.endpoint
}
