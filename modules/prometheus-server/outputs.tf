output "instance" {
   value = aws_instance.prometheus-server
 }

 output "aws_ami_id" {
    value = data.aws_ami.project-ubuntu-image.id
}

