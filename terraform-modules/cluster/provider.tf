provider "aws" {
	region = var.AWS_REGION
	shared_config_files = ["/home/beffrey/.aws/config"]
	shared_credentials_files = ["/home/beffrey/.aws/credentials"]
}

terraform {
	required_version = ">=0.12"
}