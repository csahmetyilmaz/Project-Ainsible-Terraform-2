resource "aws_subnet" "public-subnet" {
    vpc_id = var.vpc_id
    for_each = var.az_public_subnet
    availability_zone = each.key
    cidr_block = each.value
   
    tags =  {
       Name : "${var.env_prefix}-public-subnet-${each.key}"  
    }

 }

 resource "aws_subnet" "private-subnet" {
    vpc_id = var.vpc_id
    for_each = var.az_private_subnet
    availability_zone = each.key
    cidr_block = each.value
   
    tags =  {
       Name : "${var.env_prefix}-private-subnet-${each.key}"  
    }

 }

 resource "aws_subnet" "database-subnet" {
    vpc_id = var.vpc_id
    for_each = var.az_database_subnet
    availability_zone = each.key
    cidr_block = each.value
   
    tags =  {
       Name : "${var.env_prefix}-database-subnet-${each.key}"  
    }

 }


 resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = var.vpc_id
     tags = {
        Name: "${var.env_prefix}-igw"
    }
 }



resource "aws_default_route_table" "main-rtb" {

   default_route_table_id = var.default_route_table_id
   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp-igw.id

   }
   tags = {
      Name: "${var.env_prefix}-main-rtb"
   }
}

resource "aws_route_table_association" "public-rtb-association" {
    for_each = aws_subnet.public-subnet
    subnet_id = each.value.id #subnet_id=aws_subnet.public-subnet[each.key].id
    route_table_id = aws_default_route_table.main-rtb.id
  
}