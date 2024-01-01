
resource "aws_lightsail_key_pair" "deployer" {
  name       = "${var.project_name}_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUPWptulQsVugB2qEKg0N/8ZkePrn1SPxIM81MhfjIIiBZ8R2DesOsu70tC8YdyBkZz95hUuBJUqK+e7ba8Cjx8xOy58Sp2EyR9xp17VusLV1zvnQNHuxxq/8VdZIZHjxOo6EBzoMAjgwS24Ug1QJNB3/zY4wFTZkNYIGvlv/9JgGgaoGGbhS2tlXqguTGt56DlgQcdG7KMulT392ncQNLO4D3QLhxMMJa9q+COUoNv7ddUFk6DOJNjptHlAYEZnT8Z9aTD1IF7a5szPOB1hNytF93IGpbhNedH0SBf8diFEEkw3k+/sUEPBsA+QPCZhJw1nuy0Kq5di79irEx9mOOYDEsr2faW2kMzqMtBYrWsd0PLtAABKDcQNBrOLnQxXdLbgKtBQTEWNIeP58hnCUeD/NmEegkTuzeK2PF7jlbfyFIslCVLjXU7vrAJAi2nlk4EBaJV9k31oArEUL+n6aG01pYXOEkjKT1o0PbQcTtS4mthXVcnwLZSmGiXIopGM0="
}


module "lightsail_controller" {
  source                  = "../terraform-modules/lightsail_controller"
  lightsail_blueprint_id  = var.lightsail_blueprint_id
  lightsail_bundle_id     = var.lightsail_bundle_id
  name                    = "${var.project_name}-controller"
  key_name                = aws_lightsail_key_pair.deployer.name
  ssh_and_k8s_allow_cidrs = ["${var.home_public_ip}/32"]
  init_script             = file("../rsc/scripts/k8s/setup-lightsail-node.sh")
}

