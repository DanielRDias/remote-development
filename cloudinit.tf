data "cloudinit_config" "master" {
  gzip          = true
  base64_encode = true

  # get common user_data and disk
  part {
    filename     = "00-user.sh"
    content_type = "text/x-shellscript"
    content = templatefile(
      "./assets/user.sh",
      {
        device_name    = var.data_volume
        mount_point    = var.data_mount_point
        username       = var.user_name
        ssh_public_key = var.ssh_public_key
      }
    )
  }

  # get update and cloudwatch agent
  part {
    filename     = "00-setup.sh"
    content_type = "text/x-shellscript"
    content = templatefile(
      "./assets/setup.sh",
      {
        application = var.application
        username    = var.user_name
      }
    )
  }

  # get zsh 10k
  part {
    filename     = "10-zsh10k.sh"
    content_type = "text/x-shellscript"
    content = templatefile(
      "./assets/zsh10k.sh",
      {
        mount_point = var.data_mount_point
        username    = var.user_name
      }
    )
  }

  # get tools
  part {
    filename     = "20-tools.sh"
    content_type = "text/x-shellscript"
    content = templatefile(
      "./assets/tools.sh",
      {
        mount_point           = var.data_mount_point
        username              = var.user_name
        DOCKERCOMPOSE_VERSION = var.DOCKERCOMPOSE_VERSION
        GIT_EMAIL             = var.GIT_EMAIL
        GIT_NAME              = var.GIT_NAME
      }
    )
  }

  # install custom packages and brew.sh package manager
  part {
    filename     = "40-custom-packages.sh"
    content_type = "text/x-shellscript"
    content = templatefile(
      "./assets/custom-packages.sh",
      {
        username        = var.user_name
        custom_packages = var.custom_packages
        npm_packages    = var.npm_packages
        install_brew    = var.install_brew
        brew_packages   = var.brew_packages
      }
    )
  }

  # install fun packages
  part {
    filename     = "50-fun-packages.sh"
    content_type = "text/x-shellscript"
    content = templatefile(
      "./assets/fun-packages.sh",
      {
        fun_packages = var.fun_packages
        application  = var.application
      }
    )
  }

}
