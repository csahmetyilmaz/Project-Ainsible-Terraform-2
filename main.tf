resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name : "${var.env_prefix}-vpc"  #string interpolation

    }
}


data "template_file" "user_data_template_ac" {
  template = file("./modules/ansible-controller/entry-script.sh")
  vars = {
    ws_public_ip_value = module.web-server.instance.public_ip
    db_public_ip_value = module.database-server.instance.public_ip
    ps_public_ip_value = module.prometheus-server.instance.public_ip
    db_private_ip_value = module.database-server.instance.private_ip
    ps_private_ip_value = module.prometheus-server.instance.private_ip
    ws_private_ip_value = module.web-server.instance.private_ip
  }
}





module "myapp-subnet" {
    source = "./modules/subnet"
    # modulün kaynağı için main.tf den refer edeceğimiz variable'lar
    env_prefix = var.env_prefix 
    az_public_subnet= var.az_public_subnet 
    az_private_subnet = var.az_private_subnet 
    az_database_subnet = var.az_database_subnet 
    # tanımladığımız variable lar
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
    vpc_id = aws_vpc.myapp-vpc.id

}

module "ansible-controller" {
    source = "./modules/ansible-controller"
    my_ip = var.my_ip
    env_prefix = var.env_prefix 
    image_name = var.image_name
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.subnet[var.az_index].id
    availibility_zone = module.myapp-subnet.availibility_zone[var.az_index]
    my_key = var.my_key
    vpc_id = aws_vpc.myapp-vpc.id
    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
    user_data = data.template_file.user_data_template_ac.rendered

}

module "web-server" {
    source = "./modules/webserver"
    my_ip = var.my_ip
    env_prefix = var.env_prefix 
    image_name = var.image_name
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.subnet[var.az_index].id
    availibility_zone = module.myapp-subnet.availibility_zone[var.az_index]
    my_key = var.my_key
    vpc_id = aws_vpc.myapp-vpc.id
  
    
}

module "database-server" {
    source = "./modules/dbserver"
    my_ip = var.my_ip
    env_prefix = var.env_prefix 
    image_name = var.image_name
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.subnet[var.az_index].id
    availibility_zone = module.myapp-subnet.availibility_zone[var.az_index]
    my_key = var.my_key
    vpc_id = aws_vpc.myapp-vpc.id
  
    
}

module "prometheus-server" {
    source = "./modules/prometheus-server"
    my_ip = var.my_ip
    env_prefix = var.env_prefix 
    image_name = var.image_name
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.subnet[var.az_index].id
    availibility_zone = module.myapp-subnet.availibility_zone[var.az_index]
    my_key = var.my_key
    vpc_id = aws_vpc.myapp-vpc.id
    
  
   
}


resource "aws_iam_policy_attachment" "attach_policy" {
  name       = "attach_policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  roles      = [aws_iam_role.ec2_full_access_role.name]
}

resource "aws_iam_role" "ec2_full_access_role" {
  name               = "EC2FullAccessRole"
  assume_role_policy = file("/ec2_full_access_policy.json") #file("./assume_role_policy.json")
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2_Instance_Profile"
  role = aws_iam_role.ec2_full_access_role.name
}