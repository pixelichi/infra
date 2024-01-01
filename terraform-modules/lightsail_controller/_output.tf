output "public_ip" {
  value = aws_lightsail_instance.control_plane.public_ip_address
}
