variable "application" {
  default = "remote-development"
  type    = string
}

variable "data_volume" {
  default = "/dev/sdh"
  type    = string
}

variable "data_mount_point" {
  default = "/data"
  type    = string
}

variable "region" {
  default = "eu-central-1"
  type    = string
}

variable "az" {
  default = "eu-central-1a"
  type    = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "access_cidr" {
  description = "IPs or network CIDR range allowed to connect to the remote development machine"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "ec2_instance_type" {
  default = "t3a.micro"
  type    = string
}

variable "user_name" {
  default = "YOURNAME"
  type    = string
}

variable "root_volume_size" {
  default = 15
  type    = number
}


variable "data_volume_size" {
  default = 30
  type    = number
}

variable "TERRAFORM_VERSION" {
  description = "Software version installed to be installed in the remote development machine"
  default     = "0.12.29"
  type        = string
}

variable "TERRAGRUNT_VERSION" {
  description = "Software version installed to be installed in the remote development machine"
  default     = "v0.23.2"
  type        = string
}

variable "DOCKERCOMPOSE_VERSION" {
  description = "Software version installed to be installed in the remote development machine"
  default     = "1.27.4"
  type        = string
}

variable "GIT_NAME" {
  description = "Your GitHub Name"
  type        = string
  default     = ""
}

variable "GIT_EMAIL" {
  description = "Your GitHub Email"
  type        = string
  default     = ""
}

variable "ssh_public_key" {
  description = "Your public SSH key"
  type        = string
  default     = ""
}

variable "enable_scheduler" {
  description = "Set to true if you want to start/stop your instance based on start/stop_time"
  default     = false
  type        = bool
}

variable "start_time" {
  description = "Valid cron expression. e.g. cron(0 9 ? * MON-FRI *)"
  type        = string
}

variable "stop_time" {
  description = "Valid cron expression. e.g. cron(0 17 ? * MON-FRI *)"
  type        = string
}

variable "fun_packages" {
  description = "Install packages with fun included (neofetch, figlet, cowsay, lolcat,..)"
  default     = false
  type        = bool
}

variable "custom_packages" {
  description = "List of custom packages to install. Seperated by SPACES."
  default     = ""
  type        = string
}

variable "npm_packages" {
  description = "List of npm packages to install. Seperated by SPACES."
  default     = ""
  type        = string
}

variable "install_brew" {
  description = "Set to true if you want to install brew.sh package manager"
  default     = false
  type        = bool
}

variable "brew_packages" {
  description = "List of brew packages to install. Seperated by SPACES."
  default     = ""
  type        = string
}

variable "destroy_instance" {
  description = "Set to true if you want to destroy the instance but keep the data EBS volume"
  default     = false
  type        = bool
}

variable "default_tags" {
  default = {
    Name               = "remote-development"
    Application        = "remote-development"
    Owner              = "YOUR NAME"
  }
  type = map(string)
}

variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "enable_backup" {
  type    = bool
  default = false
}
