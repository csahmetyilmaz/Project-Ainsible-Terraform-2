resource "aws_security_group" "Prometheus-sg" {

    vpc_id = var.vpc_id
    name = "${var.env_prefix}-prometheus-sg"

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    }

    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    }
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"] #[var.my_ip]
      description = "SSH"
    }

    ingress {
      from_port = 9090
      to_port = 9090
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Prometheus"

    }

    ingress {
      from_port = 9100
      to_port = 9100
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Node Exporter"
    }

    ingress {
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Grafana"
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name: "${var.env_prefix}-prometheus-sg"
   }


}
data "aws_ami" "project-ubuntu-image" {
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




resource "aws_instance" "prometheus-server" {
   ami =  data.aws_ami.project-ubuntu-image.id
   instance_type = var.instance_type
   subnet_id = var.subnet_id #module.myapp-subnet-1.subnet.id
   availability_zone = var.availibility_zone
   vpc_security_group_ids = [aws_security_group.Prometheus-sg.id]
   associate_public_ip_address = true
   key_name = var.my_key
   user_data =  file("${path.module}/entry-script.sh")

   tags = {
      Name: "${var.env_prefix}-prometheus-server"
     }
}
   