output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.linux_server.id
}

output "public_ip" {
  description = "Public IP address of the Linux server"
  value       = aws_instance.linux_server.public_ip
}

output "public_dns" {
  description = "Public DNS name of the Linux server"
  value       = aws_instance.linux_server.public_dns
}

output "ssh_command" {
  description = "SSH command to connect to the server"
  value       = "ssh -i <your-key.pem> ubuntu@${aws_instance.linux_server.public_ip}"
}

output "website_url" {
  description = "Nginx website URL"
  value       = "http://${aws_instance.linux_server.public_ip}"
}

output "key_pair_name" {
  value = aws_key_pair.deployer_key.key_name
}