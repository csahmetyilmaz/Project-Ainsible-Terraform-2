resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name : "${var.env_prefix}-vpc"  #string interpolation

    }
}
module "myapp-subnet" {
    source = "./modules/subnet"
    # modulün kaynağı için main.tf den refer edeceğimiz variable'lar
    env_prefix = var.env_prefix 
    az_public_subnet= var.az_public_subnet 
    az_private_subnet = var.az_private_subnet 
    az_database_subnet = var.az_database_subnet 
    availibility_zone = var.availibility_zones 
    # tanımladığımız variable lar
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
    vpc_id = aws_vpc.myapp-vpc.id

}

module "myapp-webserver" {
    source = "./modules/webserver"
    my_ip = var.my_ip
    env_prefix = var.env_prefix 
    image_name = var.image_name
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.subnet.id
    availibility_zone = var.availibility_zones[0]
    my_public_key = var.my_public_key
    vpc_id = aws_vpc.myapp-vpc.id
}
