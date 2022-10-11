output "ingress_ip" {
  description = "Static IP of inference engine ingress"
  value       = module.address_fe.addresses[0]
}
