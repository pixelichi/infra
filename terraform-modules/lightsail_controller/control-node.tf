resource "aws_lightsail_instance" "control_plane" {
  name              = var.name
  availability_zone = "${var.region}a"
  blueprint_id      = var.lightsail_blueprint_id
  bundle_id         = var.lightsail_bundle_id
  ip_address_type   = "ipv4"
  key_pair_name     = var.key_name

  user_data = var.init_script

  # Snapshot at 2am PST
  add_on {
    type          = "AutoSnapshot"
    snapshot_time = "10:00"
    status        = "Enabled"
  }
}



resource "aws_lightsail_instance_public_ports" "control_plane" {
  instance_name = aws_lightsail_instance.control_plane.name

  port_info {
    protocol  = "tcp"
    from_port = 6443
    to_port   = 6443
    cidrs     = var.ssh_and_k8s_allow_cidrs
  }

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidrs     = var.ssh_and_k8s_allow_cidrs
  }
}
