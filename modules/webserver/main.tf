resource "aws_default_security_group" "default-sg" {

  vpc_id = var.vpc_id

    ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      #[var.my_ip]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name: "${var.env_prefix}-sg"
   }


}
data "aws_ami" "project-amazon-linux-image" {
    most_recent = true # most recent image version
    owners = ["amazon"] # image ın sahibi amazon olsun
    filter {# query in için kriterlerin neler burada belirleyebilirsin
        name = "name"
        values = [var.image_name] # başlangıcı -*- öncesi

    }    
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    } 
}
output "aws_ami_id" {
    value = data.aws_ami.project-amazon-linux-image.id
}


resource "aws_instance" "myapp-server" {
   ami = data.aws_ami.project-amazon-linux-image.id
   instance_type = var.instance_type
   subnet_id = var.subnet_id #module.myapp-subnet-1.subnet.id
   availability_zone = var.availibility_zone
   vpc_security_group_ids = [aws_default_security_group.default-sg.id]
   associate_public_ip_address = true
   key_name = var.my_public_key
   user_data =  file("${path.module}/entry-script.sh")

   tags = {
      Name: "${var.env_prefix}-server"
     }
}
   