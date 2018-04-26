FROM macpaw/internship

LABEL maintainer="vliubko@student.unit.ua"

# 1) install additional system packages
RUN		apt-get update -y
RUN		apt-get install -y zip unzip logrotate
RUN 	pip install --upgrade pip
RUN		pip install flask
RUN 	pip3 install urllib3

#RUN		apt-get install -y vim

# 2) exposing port 80
EXPOSE 80/tcp

# 3,4,5) Task to change config files. Two methods below
# method #1: using sed replace
# set correct application at uwsgi.ini file to remove Internal Server Error
RUN		sed -i "s|wsgi-file=/app/wrong.py|wsgi-file=/app/main.py |g" /app/uwsgi.ini

# method #2: using Dockerfile COPY
# change domain from localhost to internship.macpaw.io at nginx.conf file
COPY	nginx.conf /etc/nginx/conf.d/

# change pyhton script to return HTML code with info about author
COPY	main.py /app/

# 6) finding password for zip file
# you can find zip password in file /app/zip_pass.txt
COPY		zip_pass_vliubko.sh /
RUN 		chmod +x /zip_pass_vliubko.sh
RUN 		/zip_pass_vliubko.sh

### BONUS TASKS ###

# 7) add log rotation for supervisor and dpkg files at /var/log/ directory

# delete olg config for dpkg logrotate, copy my config files in container
RUN			rm -f /etc/logrotate.d/dpkg
COPY		logrotate_supervisor /etc/logrotate.d
COPY		logrotate_dpkg /etc/logrotate.d

# debug logrotate and force run logrotate
RUN			logrotate -d /etc/logrotate.d/ ; logrotate -v -f /etc/logrotate.d/ 2>/dev/null

# 8) create application, shows IP address at internship.macpaw.io/ip

COPY 		index.html /app
