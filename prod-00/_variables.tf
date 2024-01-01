variable "lightsail_blueprint_id" {
  # aws lightsail get-blueprints
  default = "ubuntu_22_04"
}

variable "lightsail_bundle_id" {
  # aws lightsail get-bundles
  default = "small_3_0"
}

variable "project_name" {
  default = "jtrack"
}

variable "home_public_ip" {
  description = "Allow traffic from this IP to do administration on the server."
}
