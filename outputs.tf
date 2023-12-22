output "controller_public_ip" {
    value = module.ansible-controller.instance.public_ip
}

output "prometheus_public_ip" {
    value = module.prometheus-server.instance.public_ip
}
