FROM     ubuntu
MAINTAINER Guilherme Hartmann "guilhermehartmann@gmail.com"

# Usage:
# docker build --rm -t ipynote .
# docker run -d -P -v `/bin/pwd`/notebooks:/notebooks -t ipynote

# Import context
ADD ./context /tmp/context

# Allows read and write on a folder
VOLUME /notebooks

# make sure the package repository is up to date
RUN apt-get update

# install sshd
RUN apt-get install -y openssh-server vim
RUN mkdir /var/run/sshd

# Adding supervisord
RUN apt-get install -y supervisor 

# Adding ipython notebook
RUN apt-get install -y python-pip ipython ipython-notebook python-matplotlib python-sklearn python-pip python-pandas python-pymc python-dev

# create user and setup sudo / keys
RUN adduser --shell /bin/bash --gecos 'debian repository dedicated user' --uid 5000 --disabled-password --home /home/dev_user dev_user
RUN cp /tmp/context/etc/sudoers /etc/sudoers
RUN cp -R /tmp/context/home/.ssh /home/dev_user
RUN cp -R /tmp/context/home/.vim /home/dev_user
RUN cp /tmp/context/home/.vimrc /home/dev_user
RUN chown -R dev_user:dev_user /home/dev_user

# Adding supervisord
RUN cp /tmp/context/etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf 

# expose ports
EXPOSE 8888
EXPOSE 22

CMD ["/usr/bin/supervisord"]
