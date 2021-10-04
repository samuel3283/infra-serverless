
variable "aws_account_id" {
	type = number
	default = 0
}

variable "aws_access_key_id" {
  description = "AWS access key"
  default = ""
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  default = ""
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "env" {
	type = string
	default = "desarrollo"
}

variable "env_lang" {
    type = string
    default = "python3.8"
}


########################### Tagging strategy ################################

variable "tag_ceco" {
	type = string
	default = "pgo1007383"
}

