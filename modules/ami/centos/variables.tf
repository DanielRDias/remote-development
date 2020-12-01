variable "os_version" {
  description = "OS version"
  type        = string
  default     = "8.2"
}

variable "arch" {
  description = "Specifies the architecture of the AMI, e.g. i386 for 32-bit, x86_64 for 64-bit, arm64 for Arm 64-bit."
  type        = string
  default     = "x86_64"
}
