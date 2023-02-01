resource "aws_instance" "web_app_server_1" {
    ami = var.AMIS[var.AWS_REGION]
    instance_type = "t2.micro"


    # VPC and subnet_id
    subnet_id = aws_subnet.main-public-1.id

    # Establish Security 
    vpc_security_group_ids = aws_security_group.allow_ssh.id


    # SSH keys   
    key_name = aws_key_pair.web_app_key.key_name
    

    tags = {
        Name = "Web App Portfolio - 1st Instance"
    }
}

resource "aws_instance" "web_app_server_2" {
    ami = var.AMIS[var.AWS_REGION]
    instance_type = "t2.micro"


    # VPC and subnet_id
    subnet_id = aws_subnet.main-public-2.id

    # Establish Security 
    vpc_security_group_ids = aws_security_group.allow_ssh.id


    # SSH keys   
    key_name = aws_key_pair.web_app_key.key_name
    

    tags = {
        Name = "Web App Portfolio - 2nd Instance"
    }
}
