output "instance" {
   value = aws_instance.database-server
 }

 output "aws_ami_id" {
    value = data.aws_ami.project-amazon-linux-image.id
}