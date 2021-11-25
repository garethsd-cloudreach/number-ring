#CREATE VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
      Name = "number-ring"
  }
}
#CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "number_ring_igw"
  }
}
#CREATE PUBLIC SUBNET
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "192.168.11.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}
#CREATE ELASTIC IP FOR NAT
resource "aws_eip" "nat_eip" {
  vpc      = true
}
#Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "NAT Gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}
#CREATE PRIVATE SUBNET
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "192.168.22.0/24"
    availability_zone = "eu-west-1a"

    tags = {
        Name = "private"
    }
}
#ROUTE TABLE FOR NAT GATEWAY
resource "aws_route_table" "private_to_public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private_to_public"
  }
}
#ROUTE TABLE TO IGW
resource "aws_route_table" "igw_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "igw_route_table"
  }
}

#ASSOCIATION TO PRIVATE
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_to_public_rt.id
}
#ASSOCIATION TO PUBLIC
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.igw_route_table.id
}

#SECURITY GROUP
resource "aws_security_group" "number_ring_sg" {
  name        = "number_ring_sg"
  description = "Allow access to my Server"
  vpc_id      = aws_vpc.main_vpc.id

#INBOUND RULES
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] #DON'T LEAVE OPEN
  }

  tags = {
      Name = "number_ring_sg"
  }
 egress {
  description = "Allow access to the world"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
}
#DEFINING AMI FOR INSTANCES
data "aws_ami" "my_aws_ami" {
    owners = [ "137112412989" ]
    most_recent = true
    filter {
        name = "name"
        values = [ "amzn2-ami-kernel-*" ]
    }
}
#EC2- PUBLIC INSTANCE
resource "aws_instance" "public_server" {
  ami = data.aws_ami.my_aws_ami.id
  instance_type = "t2.medium"
  key_name = "number-ring-key"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.number_ring_sg.id]
}


#EC2- PRIVATE INSTANCES
resource "aws_instance" "first_server" {
    ami = data.aws_ami.my_aws_ami.id
    instance_type = "t2.medium"
    key_name =  "number-ring-key"
    subnet_id = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.number_ring_sg.id]

    tags = {
        Name = "first server"
    }
}
resource "aws_instance" "second_server" {
    ami = data.aws_ami.my_aws_ami.id
    instance_type = "t2.medium"
    key_name =  "number-ring-key"
    subnet_id = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.number_ring_sg.id]

    tags = {
        Name = "second server"
    }
}
resource "aws_instance" "third_server" {
    ami = data.aws_ami.my_aws_ami.id
    instance_type = "t2.medium"
    key_name =  "number-ring-key"
    subnet_id = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.number_ring_sg.id]

    tags = {
        Name = "third server"
    }
}
resource "aws_instance" "fourth_server" {
    ami = data.aws_ami.my_aws_ami.id
    instance_type = "t2.medium"
    key_name =  "number-ring-key"
    subnet_id = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.number_ring_sg.id]

    tags = {
        Name = "fourth server"
    }
}
resource "aws_instance" "fifth_server" {
    ami = data.aws_ami.my_aws_ami.id
    instance_type = "t2.medium"
    key_name =  "number-ring-key"
    subnet_id = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.number_ring_sg.id]

    tags = {
        Name = "fifth server"
    }
}