#!/bin/bash
sudo -i
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo yum install -y postgresql12-server
sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
sudo systemctl enable postgresql-12
sudo systemctl start postgresql-12
sudo rpm -i https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-redhat-repo-2-1.noarch.rpm
sudo yum install -y pgadmin4-web
sudo yum install expect
cat << 'EOF' > pgadmin-setup.sh
#!/usr/bin/expect -f
spawn sudo /usr/pgadmin4/bin/setup-web.sh --yes
expect "Enter the email address and password to use for the initial pgAdmin user account:"
send "email@example.com\r"
expect "Email address:"
send "password\r"
expect "Password:"
send "password\r"
interact
EOF
chmod +x pgadmin-setup.sh
./pgadmin-setup.sh









