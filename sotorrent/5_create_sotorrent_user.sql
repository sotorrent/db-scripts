# on Ubuntu 16.04 LTS, edit /etc/mysql/mysql.conf.d/mysqld.cnf
# bind-address = 127.0.0.1 --> bind-address = 0.0.0.0
# to allow remote access

CREATE USER 'sotorrent'@'localhost' IDENTIFIED BY '<PASSWORD>';
CREATE USER 'sotorrent'@'%' IDENTIFIED BY '<PASSWORD>';
GRANT ALL PRIVILEGES ON sotorrent17_12.* TO 'sotorrent'@'localhost';
GRANT ALL PRIVILEGES ON sotorrent17_12.* TO 'sotorrent'@'%';
FLUSH PRIVILEGES;
