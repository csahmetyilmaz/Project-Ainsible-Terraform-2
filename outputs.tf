output "controller_public_ip" {
    value = module.ansible-controller.instance.public_ip
}

output "prometheus_public_ip" {
    value = module.prometheus-server.instance.public_ip
}

output "dbserver_public_ip" {
    value = module.database-server.instance.public_ip
}
output "webserver_public_ip" {
    value = module.web-server.instance.public_ip
}