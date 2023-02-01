resource "aws_key_pair" "web_app_key" {
    key_name = "web_app_key"
    public_key = file (var.PATH_TO_PUB_KEY)
}