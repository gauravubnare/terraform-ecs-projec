variable "image_id" {
  default = "your_account_id.dkr.ecr.eu-west-2.amazonaws.com/rolax-repo"
}

variable "acm_arn" {
  default = "your_ssl_arn"
}

variable "domain" {
  default = "demo.letslearntech.com"
}
variable "sns-email" {
  default = "email@gmail.com"
}