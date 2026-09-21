#!/bin/bash

apt-get update -y

apt-get install -y nginx

systemctl enable nginx
systemctl start nginx

cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Terraform Linux Server</title>
</head>
<body>
    <h1>Hello from Aleem's Terraform Linux Server!</h1>
    <p>Module 2 - Linux, Networking & Cloud Infrastructure</p>
    <p>Deployed using Terraform, AWS EC2, Ubuntu and Nginx.</p>
</body>
</html>
EOF