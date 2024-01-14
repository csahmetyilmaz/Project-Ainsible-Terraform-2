
output "ws_public_ip" {
  value = module.web-server.instance.public_ip
}

output "db_public_ip" {
  value = module.database-server.instance.public_ip
}

output "ps_public_ip" {
  value = module.prometheus-server.instance.public_ip
}

output "ac_public_ip" {
  value = module.ansible-controller.instance.public_ip
}

output "db_private_ip" {
  value = module.database-server.instance.private_ip
}

output "ps_private_ip" {
  value = module.prometheus-server.instance.private_ip
}

output "ws_private_ip" {
  value = module.web-server.instance.private_ip
}

output "ac_private_ip" {
    value = module.ansible-controller.instance.private_ip
  
}