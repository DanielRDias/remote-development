output "privateip" {
  description = "EC2 private IP"
  value       = aws_instance.dev.*.private_ip
}

output "instanceid" {
  description = "EC2 instance ID"
  value       = aws_instance.dev.*.id
}
