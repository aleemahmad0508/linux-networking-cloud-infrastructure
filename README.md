# Linux, Networking & Cloud Infrastructure

A hands-on cloud infrastructure project completed as part of my internship training.
This project demonstrates the deployment and configuration of a **Linux server on AWS EC2 using Terraform**, along with Linux administration, networking, SSH, security groups, and Nginx web service deployment.

---

## 📌 Project Overview

The goal of this project was to understand and practically implement the following workflow:

```text
Create VM
   ↓
Configure Linux
   ↓
Secure Access using SSH
   ↓
Configure Networking
   ↓
Configure Security Groups
   ↓
Deploy Web Service
   ↓
Test Connectivity
```

The infrastructure was provisioned using **Terraform**, while the Linux server was configured through **SSH and Linux CLI commands**.

---

## 🎯 Objectives

The main objectives of this project were to:

* Learn basic Linux CLI operations
* Understand Linux files and directories
* Work with Linux users and groups
* Understand file ownership and permissions
* Learn process and service management
* Understand SSH and SSH key pairs
* Understand IP addressing and routing
* Learn DNS basics
* Understand ports and network connectivity
* Configure AWS Security Groups
* Deploy a Linux server on AWS EC2
* Deploy an Nginx web server
* Test HTTP and network connectivity
* Practice Infrastructure as Code using Terraform

---

## 🛠️ Technologies Used

| Technology   | Purpose                                |
| ------------ | -------------------------------------- |
| AWS          | Cloud infrastructure                   |
| EC2          | Linux virtual machine                  |
| VPC          | Virtual private network                |
| Terraform    | Infrastructure as Code                 |
| Ubuntu Linux | Server operating system                |
| SSH          | Secure remote server access            |
| Nginx        | Web server                             |
| Git & GitHub | Version control and project submission |

---

# 🏗️ Architecture

The infrastructure created in this project follows this architecture:

```text
                         Internet
                            |
                            |
                    Internet Gateway
                            |
                            |
                     Public Route Table
                            |
                            |
                     Public Subnet
                      10.0.1.0/24
                            |
                            |
                     AWS EC2 Instance
                      Ubuntu Linux
                            |
                +-----------+-----------+
                |                       |
              SSH                     HTTP
             Port 22                  Port 80
                |                       |
                |                       |
             Secure                  Nginx
             Access                Web Server
                                        |
                                        |
                              Custom Web Page
```

The EC2 instance is deployed inside a custom VPC with a public subnet and Internet Gateway.

---

# ☁️ AWS Infrastructure

Terraform creates the following AWS resources:

### 1. VPC

A custom VPC is created with:

```text
CIDR: 10.0.0.0/16
```

DNS support and DNS hostnames are enabled.

---

### 2. Public Subnet

A public subnet is created:

```text
CIDR: 10.0.1.0/24
```

The subnet is configured to automatically assign public IP addresses to launched instances.

---

### 3. Internet Gateway

An Internet Gateway provides connectivity between the VPC and the Internet.

```text
EC2
 ↓
Public Subnet
 ↓
Route Table
 ↓
Internet Gateway
 ↓
Internet
```

---

### 4. Route Table

The public route table contains a default route:

```text
0.0.0.0/0
```

which points to the Internet Gateway.

---

### 5. Security Group

The EC2 Security Group allows:

| Port | Protocol | Purpose |
| ---- | -------- | ------- |
| 22   | TCP      | SSH     |
| 80   | TCP      | HTTP    |

Outbound traffic is allowed so the server can communicate with external services.

> **Note:** This is a learning/internship configuration. In production environments, SSH access should generally be restricted to trusted source IP addresses rather than being open to the entire Internet.

---

# 🔐 SSH Key Management

Terraform automatically generates an RSA SSH key using the TLS provider.

```hcl
resource "tls_private_key" "generated_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

The public key is registered with AWS as an EC2 key pair.

Terraform also saves the private key locally as:

```text
<project-name>-key.pem
```

The private key is protected using:

```text
0400
```

permissions.

### Important

The private `.pem` file is **not committed to GitHub**.

---

# 🖥️ EC2 Linux Server

The project provisions an Ubuntu Linux EC2 instance.

The server is configured with:

* Public IP address
* Private IP address
* SSH access
* HTTP access
* 10 GB GP3 root volume
* Custom VPC
* Public subnet
* Security Group

---

# 🔑 Connecting to the Server

After Terraform creates the infrastructure, the generated private key can be used to connect to the EC2 instance.

First, set the correct permissions:

```bash
chmod 400 <project-name>-key.pem
```

Then connect:

```bash
ssh -i <project-name>-key.pem ubuntu@<EC2_PUBLIC_IP>
```

Example:

```bash
ssh -i linux-internship-key.pem ubuntu@13.XX.XX.XX
```

---

# 🐧 Linux Administration

After connecting to the EC2 instance, several Linux administration tasks were performed.

## System Information

```bash
whoami
hostname
pwd
uname -a
cat /etc/os-release
```

These commands were used to understand the current user, hostname, working directory, kernel, and operating system.

---

# 📁 File and Directory Management

The following Linux operations were practiced:

```bash
mkdir
touch
ls
ls -la
cp
mv
rm
cat
```

Example:

```bash
mkdir ~/internship-demo
cd ~/internship-demo
touch app.txt
echo "Linux Cloud Infrastructure Internship" > app.txt
cat app.txt
```

---

# 👥 Users and Groups

A Linux group was created:

```bash
sudo groupadd devops
```

A new Linux user was created:

```bash
sudo useradd -m -s /bin/bash devuser
```

The user was added to the group:

```bash
sudo usermod -aG devops devuser
```

Groups were checked using:

```bash
groups devuser
```

---

# 🔒 Linux File Permissions

Linux file ownership and permissions were practiced using:

```bash
ls -l
```

Ownership was changed using:

```bash
sudo chown devuser:devops app.txt
```

Permissions were changed using:

```bash
chmod 640 app.txt
```

This provided practical experience with:

* File ownership
* Users
* Groups
* Read permissions
* Write permissions
* Execute permissions
* `chmod`
* `chown`

---

# ⚙️ Process Management

Running processes were inspected using:

```bash
ps aux
```

Interactive process monitoring was performed using:

```bash
top
```

System resources were also checked using:

```bash
free -h
df -h
uptime
```

These commands helped understand:

* CPU/process activity
* Memory usage
* Disk usage
* System uptime
* System load

---

# 🔧 Linux Services

Linux services were managed using `systemctl`.

For example:

```bash
sudo systemctl status ssh
```

The service status can be checked to confirm whether SSH is running.

Other useful commands include:

```bash
systemctl list-units --type=service
```

and:

```bash
sudo systemctl status cron
```

---

# 🌐 Networking

Several Linux networking commands were used to inspect and test the server.

## IP Address

```bash
ip addr
```

This displays the network interfaces and IP addresses of the server.

---

## Routing

```bash
ip route
```

This displays the server's routing table.

---

## Internet Connectivity

```bash
ping -c 4 8.8.8.8
```

This tests connectivity to an external IP address.

---

# 🌍 DNS

DNS resolution was tested using:

```bash
nslookup google.com
```

If required, DNS utilities can be installed with:

```bash
sudo apt update
sudo apt install dnsutils -y
```

DNS testing helps verify that the server can resolve domain names into IP addresses.

---

# 🔌 Ports

Listening ports were checked using:

```bash
sudo ss -tulpn
```

The main ports used by this project are:

```text
22 → SSH
80 → HTTP
```

---

# 🌐 Nginx Web Server

Nginx was installed on the Linux server:

```bash
sudo apt update
sudo apt install nginx -y
```

The service was checked using:

```bash
sudo systemctl status nginx
```

Nginx was then used to serve a custom HTML page.

---

# 📝 Custom Web Page

The default Nginx webpage was replaced with a custom page.

The webpage was created at:

```text
/var/www/html/index.html
```

Example:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Linux Cloud Internship</title>
</head>
<body>
    <h1>Linux Cloud Infrastructure</h1>
    <p>Server deployed successfully using Terraform and AWS EC2.</p>
    <p>Student: Aleem Khan</p>
</body>
</html>
```

After modifying the page, Nginx was restarted:

```bash
sudo systemctl restart nginx
```

---

# 🧪 Connectivity Testing

The deployed web service was tested locally using:

```bash
curl http://localhost
```

HTTP headers were checked using:

```bash
curl -I http://localhost
```

Expected result:

```text
HTTP/1.1 200 OK
```

The website was also accessed through a web browser using:

```text
http://<EC2_PUBLIC_IP>
```

This confirmed that:

```text
Internet
   ↓
AWS Security Group
   ↓
EC2 Port 80
   ↓
Nginx
   ↓
Custom HTML Page
```

was working correctly.

---

# 📂 Project Structure

```text
linux-networking-cloud-infrastructure/
│
├── README.md
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   ├── user-data.sh
│   └── .gitignore
│
├── linux/
│   └── linux-commands.md
│
├── screenshots/
│   ├── ec2-running.png
│   ├── ssh-connected.png
│   ├── linux-system.png
│   ├── users-groups.png
│   ├── permissions.png
│   ├── processes.png
│   ├── nginx-running.png
│   ├── nginx-browser.png
│   └── connectivity.png
│
└── docs/
    └── internship-report.md
```

---

# 🚀 Terraform Deployment

## Prerequisites

Before running the project, install:

* Terraform
* AWS CLI
* Git
* An AWS account

Configure AWS credentials using the AWS CLI or another supported authentication method.

---

## Initialize Terraform

Navigate to the Terraform directory:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

---

## Validate Configuration

```bash
terraform validate
```

---

## Review the Plan

```bash
terraform plan
```

---

## Deploy Infrastructure

```bash
terraform apply
```

Confirm the deployment by entering:

```text
yes
```

---

## View Outputs

```bash
terraform output
```

The outputs can include information such as:

* EC2 public IP
* EC2 private IP
* SSH connection information

---

# 🧹 Destroy Infrastructure

When the internship lab is finished, the infrastructure can be removed with:

```bash
terraform destroy
```

Confirm with:

```text
yes
```

This helps avoid unnecessary AWS charges.

---

# 🔐 Security Considerations

The following security practices were followed:

* SSH private key is stored locally
* `.pem` files are excluded from Git
* Terraform state files are excluded from Git
* AWS credentials are not stored in the repository
* SSH access is protected using an SSH key
* Security Groups control inbound traffic

For production environments, additional security measures should be implemented, including:

* Restricting SSH source IPs
* Using IAM least privilege
* Avoiding hardcoded credentials
* Using remote Terraform state securely
* Enabling monitoring and logging
* Applying regular OS security updates

---

# 📸 Project Evidence

Screenshots were captured during the project to demonstrate successful completion.

Evidence includes:

1. AWS EC2 instance running
2. Terraform deployment
3. SSH connection
4. Linux system information
5. Linux users and groups
6. File permissions
7. Process management
8. Nginx service running
9. Custom webpage
10. Network and connectivity testing

---

# 📚 Key Learnings

Through this project, I gained practical experience in:

* AWS EC2
* AWS VPC
* Public subnets
* Internet Gateways
* Route tables
* Security Groups
* Terraform
* Infrastructure as Code
* Linux administration
* SSH
* Users and groups
* Linux permissions
* Process management
* Service management
* IP addressing
* DNS
* Ports
* Nginx
* HTTP connectivity
* Git and GitHub

---

# 🎯 Internship Task Completion

This project covers the following internship objectives:

| Requirement            | Status      |
| ---------------------- | ----------- |
| Linux CLI operations   | ✅ Completed |
| Files and directories  | ✅ Completed |
| Users and groups       | ✅ Completed |
| Permissions            | ✅ Completed |
| Process management     | ✅ Completed |
| Services               | ✅ Completed |
| SSH keys               | ✅ Completed |
| IP addressing          | ✅ Completed |
| DNS                    | ✅ Completed |
| Ports                  | ✅ Completed |
| Security Groups        | ✅ Completed |
| Linux EC2 server       | ✅ Completed |
| Web service deployment | ✅ Completed |
| Connectivity testing   | ✅ Completed |
| Infrastructure as Code | ✅ Completed |

---

# 👨‍💻 Author

**Aleem Khan**

BS Mathematics Student | DevOps & Cloud Engineering Learner

Interested in:

* DevOps
* Cloud Engineering
* Kubernetes
* Infrastructure as Code
* AWS
* Linux
* Automation

---

# 📌 Conclusion

This project provided hands-on experience in deploying and managing a Linux server in AWS. Terraform was used to automate the infrastructure, while SSH and Linux CLI were used to configure and manage the server.

The final setup successfully demonstrated the complete workflow:

```text
Terraform
    ↓
AWS VPC
    ↓
Public Subnet
    ↓
EC2 Linux Server
    ↓
SSH
    ↓
Linux Configuration
    ↓
Networking
    ↓
Security Group
    ↓
Nginx
    ↓
Custom Web Application
    ↓
Connectivity Testing
```

This project strengthened my practical foundation in **Linux, Networking, AWS Cloud, Terraform, and DevOps**.
