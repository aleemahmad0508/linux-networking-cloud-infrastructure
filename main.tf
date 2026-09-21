# ==========================================
# 1. TERRAFORM & PROVIDER CONFIGURATION
# ==========================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region # Removed the duplicate provider block below
}



# ==========================================
# 3. NETWORK RESOURCES (VPC, Subnet, Routing)
# ==========================================
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a" # Dynamically targets the first AZ of your selected region

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# ==========================================
# 4. SECURITY GROUPS
# ==========================================
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow inbound web traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==========================================
# 5. KEY PAIR GENERATION
# ==========================================
resource "tls_private_key" "generated_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.generated_ssh_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.generated_ssh_key.private_key_pem
  filename        = "${path.module}/${var.project_name}-key.pem"
  file_permission = "0400"
}

# ==========================================
# 6. COMPUTE RESOURCE (EC2 Instance)
# ==========================================
resource "aws_instance" "linux_server" {
  ami           = "ami-0c7217cdde317cfec" # Ensure this AMI is valid for your selected var.aws_region
  instance_type = var.instance_type
  
  # FIXED: Now uses the key pair generated above instead of an unlinked variable
  key_name      = aws_key_pair.deployer_key.key_name

  subnet_id              = aws_subnet.public_subnet.id 
  vpc_security_group_ids = [aws_security_group.web_sg.id] 
  
  # Note: Ensure you have a 'user-data.sh' file in the same directory, or comment this line out
  user_data = fileexists("${path.module}/user-data.sh") ? file("${path.module}/user-data.sh") : null

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name    = var.project_name
    Project = var.project_name
  }
}
