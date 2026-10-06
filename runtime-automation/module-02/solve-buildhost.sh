#!/bin/bash
# Solve script for Module 02: Configure LAMP Application
# This completes the LAMP configuration automatically

set -e

echo "Solving Module 02..." >> /tmp/progress.log

# Ensure container is running (from Module 01)
if ! podman ps | grep -q lamp-dev; then
    echo "ERROR: lamp-dev container must be running from Module 01" >> /tmp/progress.log
    exit 1
fi

# Start MariaDB
podman exec lamp-dev systemctl start mariadb

# Create database setup script
podman exec lamp-dev bash -c "cat > /app/db-setup.sql << 'EOF'
CREATE DATABASE IF NOT EXISTS hellodb;
CREATE USER IF NOT EXISTS 'hellouser'@'localhost' IDENTIFIED BY 'SecurePassword';
GRANT ALL PRIVILEGES ON hellodb.* TO 'hellouser'@'localhost';
FLUSH PRIVILEGES;
USE hellodb;
CREATE TABLE IF NOT EXISTS greetings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO greetings (message) VALUES ('Hello, World!');
INSERT INTO greetings (message) VALUES ('Welcome to LAMP with Image Mode!');
EOF"

# Initialize database
podman exec lamp-dev mariadb -u root < /home/rhel/lamp-dev/bootc/app/db-setup.sql

# Create PHP application
podman exec lamp-dev bash -c "cat > /app/index.php << 'PHPEOF'
<!DOCTYPE html>
<html>
<head>
    <title>LAMP Application</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f5f5f5; }
        h1 { color: #c00; }
        .message { background: white; padding: 20px; margin: 10px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>LAMP Application</h1>
    <?php
    \$pdo = new PDO(\"mysql:host=127.0.0.1;dbname=hellodb\", \"hellouser\", \"SecurePassword\");
    \$stmt = \$pdo->query(\"SELECT message, created_at FROM greetings ORDER BY created_at DESC\");
    echo \"<h2>Messages:</h2>\";
    while (\$row = \$stmt->fetch()) {
        echo \"<div class='message'><strong>\" . htmlspecialchars(\$row[\"message\"]) . \"</strong></div>\";
    }
    ?>
</body>
</html>
PHPEOF"

# Deploy PHP to Apache
podman exec lamp-dev cp /app/index.php /var/www/html/

# Create Apache config
podman exec lamp-dev bash -c "cat > /app/myapp.conf << 'EOF'
<VirtualHost *:80>
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        Require all granted
    </Directory>
</VirtualHost>
EOF"

# Deploy Apache config
podman exec lamp-dev cp /app/myapp.conf /etc/httpd/conf.d/

# Start Apache
podman exec lamp-dev systemctl start httpd

echo "Module 02 solve completed" >> /tmp/progress.log
exit 0
