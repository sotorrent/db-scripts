CREATE USER 'sotorrent'@'localhost' IDENTIFIED BY '<PASSWORD>';
CREATE USER 'sotorrent'@'%' IDENTIFIED BY '<PASSWORD>';
GRANT ALL PRIVILEGES ON sotorrent19_03.* TO 'sotorrent'@'localhost';
GRANT ALL PRIVILEGES ON sotorrent19_03.* TO 'sotorrent'@'%';
GRANT FILE ON *.* TO 'sotorrent'@'localhost';
GRANT FILE ON *.* TO 'sotorrent'@'%';
FLUSH PRIVILEGES;
