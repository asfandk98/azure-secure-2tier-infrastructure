output "web_public_ip" {
  description = "Public IP of the web tier VM"
  value       = azurerm_public_ip.web.ip_address
}

output "web_private_ip" {
  description = "Private IP of the web tier VM"
  value       = azurerm_network_interface.web.private_ip_address
}

output "db_private_ip" {
  description = "Private IP of the database tier VM"
  value       = azurerm_network_interface.db.private_ip_address
}
