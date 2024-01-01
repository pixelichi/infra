variable "region" {
  default = "us-east-2"
}

variable "lightsail_blueprint_id" {
  # aws lightsail get-blueprints
  default = "amazon_linux_2023"
}

variable "lightsail_bundle_id" {
  # aws lightsail get-bundles
  default = "micro_3_0"
}

variable "name" {
}

variable "key_name" {
  description = "Name of the aws_lightsail_key_pair for accessing the lightsail instance."
}

variable "ssh_and_k8s_allow_cidrs" {
  type        = list(string)
  description = "The lightsail instance will allow traffic from these cidr blocks on port 6443 and 22 for making kubernetes changes and sshing."
}

variable "init_script" {
  type        = string
  description = "Script to run after the lightsail instance comes up."
}
