# Security Group Docker
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow SSH"
  }
}
# Security Group Tomcat
resource "aws_security_group" "allow_Tomcat" {
  name        = "allow_Tomcat"
  description = "Allow Tomcat inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Tomcat from Anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Tomcat"
  }
}


# Key Pair
resource "aws_key_pair" "my_WIN_key" {
  key_name   = "WIN-key"
  public_key = file(var.PATH_TO_PUB_KEY)
}

# Instance-Docker
resource "aws_instance" "docker" {
  ami           = var.AWS_AMI[var.AWS_REGION]
  instance_type = "t2.micro"

  # Select Subnet
  subnet_id = aws_subnet.main_public_1.id

  # Delete rootVolume on Termination 
  root_block_device {
    delete_on_termination = true
  }

  # Select Security Group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_Tomcat.id]

  # Select Key
  key_name = aws_key_pair.my_WIN_key.id

  # Select IP
  private_ip = "10.0.1.81"

  # Select user_data
  user_data = file("install.sh")

  # Tag
  tags = {
    Name = "docker"
  }

}

