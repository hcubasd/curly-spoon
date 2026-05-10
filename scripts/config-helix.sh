set -e

# yaml
npm i -g yaml-language-server @ansible/ansible-language-server

# docker-compose
npm i -g @microsoft/compose-language-service

# sql
curl -sL https://github.com/sqls-server/sqls/releases/download/v0.2.45/sqls-linux-0.2.45.zip -o /tmp/sqls.zip
unzip -o /tmp/sqls.zip sqls -d /usr/local/bin
rm /tmp/sqls.zip
pip install sqlfluff
