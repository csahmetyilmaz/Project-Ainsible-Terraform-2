output "subnet" {
     value = values(aws_subnet.public-subnet)
}

output "availibility_zone" {
     value = keys(aws_subnet.public-subnet)
  
}