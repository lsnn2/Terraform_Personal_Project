#!/bin/bash
yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum install -y postgresql12-server
/usr/pgsql-12/bin/postgresql-12-setup initdb
systemctl enable postgresql-12
systemctl start postgresql-12
rpm -i https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-redhat-repo-2-1.noarch.rpm
yum install -y pgadmin4-web
yum install -y expect
cat << 'EOF' > pgadmin-setup.sh
#!/usr/bin/expect -f
spawn /usr/pgadmin4/bin/setup-web.sh --yes
expect "Email address:"
send "edwardli105@gmail.com\r"
expect "Password:"
send "password\r"
expect "Retype Password:"
send "password\r"
interact
EOF
chmod +x pgadmin-setup.sh
./pgadmin-setup.sh








