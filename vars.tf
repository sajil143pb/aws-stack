variable "REGION" {
  default = "us-east-2"
}

variable "zone" {
  default = "us-east-2a"
}

variable "AMIS" {
  type = map
  default = {
    us-east-2 = "ami-02f3416038bdb17fb"
    us-east-1 = "ami-02f3416038bdb17fb"
  }
}
