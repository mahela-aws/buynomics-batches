# Default vpc is used for compute environment
resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_subnet" {
  availability_zone = "us-east-1a"
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
