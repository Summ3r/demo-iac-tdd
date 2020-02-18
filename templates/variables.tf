variable "access_key" {
  default = "AKIAU4EIEQSAO7OPKCBC"
}

variable "secret_key" {
  default = "IRBi4IA+37xMv9MXZqLAQ+e4t2lPQVB25slv3wr7"
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

