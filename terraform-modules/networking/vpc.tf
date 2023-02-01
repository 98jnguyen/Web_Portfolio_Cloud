# Defines all Networking

# Internet VPC
resource "aws_vpc" "main" {
	cidr_block		= "10.0.0.0/16"
	instance_tenancy	= "default"
	enable_dns_support	= "true"
	enable_dns_hostnames	= "true"
	# enable_classiclink 	= "false"
	tags = {
	 Name = "main VPC"
	}
}

# Subnets Defined - US WEST with 2 public, 2 private subnets - connected with IG
resource "aws_subnet" "main-public-1" {
	vpc_id				= aws_vpc.main.id
	cidr_block			= "10.0.1.0/24"
	map_public_ip_on_launch 	= "true"
	availability_zone		= "us-west-1a"
	tags = {
	 Name = "main-public-1"
	 "kubernetes.io/role/internal-elb"	=	"1"
	 "kubernetes.io.cluster/web"	=	"owned"
	}
}

resource "aws_subnet" "main-public-2" {
	vpc_id 				= aws_vpc.main.id
	cidr_block			= "10.0.2.0/24"
	map_public_ip_on_launch         = "true"
        availability_zone               = "us-west-1c"
        tags = {
         Name = "main-public-2"
		 "kubernetes.io/role/internal-elb"	=	"1"
	 	 "kubernetes.io.cluster/web"	=	"owned"
        }
}

resource "aws_subnet" "main-private-1" {
	vpc_id				= aws_vpc.main.id
	cidr_block			= "10.0.3.0/24"
	map_public_ip_on_launch         = "false"
        availability_zone               = "us-west-1a"
        tags = {
         Name = "main-private-1"
		 "kubernetes.io/role/internal-elb"	=	"1" 
		 "kubernetes.io.cluster/web"	=	"owned"
        }
}

resource "aws_subnet" "main-private-2" {
        vpc_id                          = aws_vpc.main.id
        cidr_block                      = "10.0.4.0/24"
        map_public_ip_on_launch         = "false"
        availability_zone               = "us-west-1c"
        tags = {
         Name = "main-private-2"
		"kubernetes.io/role/internal-elb"	=	"1"
		"kubernetes.io.cluster/web"	=	"owned"
        }
}

# Internet Gateway Established - attached to VPC
resource "aws_internet_gateway" "main-gw" {
	vpc_id	= aws_vpc.main.id
	tags = {
	 Name = "main"
	}
}

#NAT Established for Public IP
resource "aws_eip" "nat" {
	vpc	=	true
	
	tags = {
		Name = "nat"
	}
}

resource "aws_nat_gateway" "nat" {
	allocation_id = aws_eip.nat.subnet_id
	subnet_id	=	aws_subnet.main-public-1.subnet_id

	tags = {
		Name	=	"nat"
	}

	depends_on = [aws_internet_gateway.main-gw]
}

# Routing Table Definitions
resource "aws_route_table" "main-public" {
	vpc_id		=	aws_vpc.main.id
	route {
	 cidr_block	= "0.0.0.0/0"
	 gateway_id	=	aws_internet_gateway.main-gw.id
	}
	tags = {
	 Name = "main-public"
	}
}

resource "aws_route_table" "main-private" {
	vpc_id		=	aws_vpc.main.id
	route {
	 cidr_block	= "0.0.0.0/0"
	 nat_gateway_id	=	aws_nat_gateway.nat.id
	}
	tags = {
	 Name = "main-private"
	}
}

# Routing Associations to Public
resource "aws_route_table_association" "main-public-1a" {
	subnet_id	=	aws_subnet.main-public-1.id
	route_table_id	=	aws_route_table.main-public.id
}

resource "aws_route_table_association" "main-public-1c" {
        subnet_id       =       aws_subnet.main-public-2.id
        route_table_id  =       aws_route_table.main-public.id
}

#Routing Associations to Private
resource "aws_route_table_association" "main-private-1a" {
	subnet_id	=	aws_subnet.main-private-1.id
	route_table_id	=	aws_route_table.main-private.id
}

resource "aws_route_table_association" "main-private-1c" {
	subnet_id	=	aws_subnet.main-private-2.id
	route_table_id	=	aws_route_table.main-private.id
}

# Security Groups 
resource "aws_security_group" "allow_ssh" {
	name	=	"allow_ssh"
	description	=	"allows SSH traffic"
	vpc_id 	=	aws_vpc.main.id

	egress {
		from_port	= 0
		to_port	= 0
		protocol	= "-1"
		cidr_blocks = ["0.0.0.0/0"]
		}
	ingress {
		from_port	= 22
		to_port	= 22
		protocol	= "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		}
		tags = {
			Name = "allow_ssh"
		}

}