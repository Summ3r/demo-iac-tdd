variable "access_key" {
  default = "AKIAJJOVNGGJUZFYIQAA"
}

variable "secret_key" {
  default = "Y5gWV9ZIo+ky8H5OTqqv30BggBqPL84ttSeeG1x6"
}

variable "region" {
  default = "eu-west-2" // London
}

variable "instace_count" {
  default = 2
}

variable "ssh_key_name" {
  default = "atom-ec2-key"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "amis" {
  default = "ami-0389b2a3c4948b1a0"
}

