cp ~/.ssh/id_rsa.pub ./context/home/.ssh/authorized_keys

docker build --rm -t ipynote .
