output "ingress_ip" {
  description = "Static IP of inference engine ingress"
  value       = module.address_fe.addresses[0]
}

output "default_password" {
  description = "Generated password of default user"
  value       = base64decode(data.kubernetes_secret.default_password.binary_data.password)
  sensitive   = true
}
