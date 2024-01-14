variable aws_region {}
variable vpc_cidr_block{}

variable default_route_table_id{}
variable env_prefix {}
variable vpc_id{}
variable az_public_subnet { type = map(string) }
variable az_private_subnet { type = map(string) }
variable az_database_subnet { type = map(string) }


variable my_ip{}
variable image_name{}
variable my_key{}
variable instance_type{}
variable az_index {type=number}

