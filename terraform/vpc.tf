# Default vpc is used for compute environment
resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_subnet" {
  availability_zone = "us-east-1a"
}

# creates private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_default_vpc.default_vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = "us-east-1a"

}

# creates eip for nat gateway
resource "aws_eip" "eip" {
  vpc = true
}

# creates nat gateway
resource "aws_nat_gateway" "nat" {
  # allocating eip of the nat gateway
  allocation_id = aws_eip.eip.id

  # associating it in the public subnet
  subnet_id = aws_default_subnet.default_subnet.id
}

# creates private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_default_vpc.default_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

# creates private route table association for private subnet
resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create a security group for compute environment.
resource "aws_security_group" "bn_conpute_environment_sg" {
  name        = "bn-compute-environment-sg"
  description = "Security group for compute environment."
  vpc_id      = aws_default_vpc.default_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
