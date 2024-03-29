resource "aws_default_security_group" "default-sg" {

  vpc_id = var.vpc_id

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    }
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH"
      #[var.my_ip]
    }

    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
      
    }
     ingress {
      from_port = 9100
      to_port = 9100
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Prometheus Node Exporter"
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name: "${var.env_prefix}-controller-sg"
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


resource "aws_instance" "ansible-controller" {
   ami =  data.aws_ami.project-amazon-linux-image.id
   instance_type = var.instance_type
   subnet_id = var.subnet_id #module.myapp-subnet-1.subnet.id
   availability_zone = var.availibility_zone
   vpc_security_group_ids = [aws_default_security_group.default-sg.id]
   associate_public_ip_address = true
   key_name = var.my_key
   user_data =  var.user_data
   iam_instance_profile=var.iam_instance_profile

   tags = {
      Name: "${var.env_prefix}-controller"
     }

      connection {
        type = "ssh"
        host = self.public_ip
        user = "ec2-user"
        private_key = file("${var.my_key}.pem")
    }


      provisioner "file" {
   # dosyaları veya directory leri local dan eni oluşturulan resource a kopyalar.
        source ="${path.module}/Ansible-Website-Project"
        destination = "/home/ec2-user/"
    }
  
      provisioner "file" {
    # dosyaları veya directory leri local dan eni oluşturulan resource a kopyalar.
        source ="${var.my_key}.pem"
      destination = "/home/ec2-user/Ansible-Website-Project/${var.my_key}.pem" # cmd ye pwd yaptığımız zaman çıkan yer
    }

    provisioner "remote-exec" {
    inline = [
      "cd /home/ec2-user/Ansible-Website-Project",
      "sudo chmod 400 ${var.my_key}.pem", 
              ]

    }



     provisioner "remote-exec" {
     inline = [
      "echo 'ansible_controller_ip: ${self.public_ip}' >> /home/ec2-user/vars.yml",
      "echo 'ansible_controller_private_ip: ${self.private_ip}' >> /home/ec2-user/vars.yml",
            ]
    }


#    provisioner "local-exec" {
#  #  dosyaları veya directory leri local dan eni oluşturulan resource a kopyalar. Gizli dosyaları (başında . olanlar) kopyala
#        command = "scp -r -i ${var.my_key}.pem ${path.module}/Ansible-Website-Project/{*,.*} ec2-user@${self.public_ip}:/home/ec2-user/Ansible-Website-Project/"
#}

}

resource "null_resource" "ansible_controller" {
  triggers = {
    private_ip = aws_instance.ansible-controller.private_ip
  }

}


 

   