output "instance" {
   value = aws_instance.ansible-controller
 }

 
output "aws_ami_id" {
    value = data.aws_ami.project-amazon-linux-image.id
}

output "sg" {
  value = aws_default_security_group.default-sg
  
}

output "target_ip" {
  value = aws_instance.ansible-controller.public_ip
}

output "private_ip" {
  value = aws_instance.ansible-controller.private_ip
}

