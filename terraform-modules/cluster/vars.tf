variable "AWS_REGION" {
    default = "us-west-1"
}

variable "PATH_TO_PRIV_KEY" {
    default = "web_app_key"
}

variable "PATH_TO_PUB_KEY" {
    default = "web_app_key.pub"
}

variable "AMIS" {
    type = map(string)
    default = {
	 us-west-1 = "ami-0454207e5367abf01"
	 us-west-2 = "ami-0688ba7eeeeefe3cd"
	 us-east-1 = "ami-0b0ea68c435eb488d"
    }
}