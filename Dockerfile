FROM ubuntu:latest
RUN apt update && apt install  openssh-server sudo emacs build-essential default-jdk default-jre cmake git -y

# Create a user “siril” and group “sshgroup”
RUN groupadd sshgroup && useradd -ms /bin/bash -g sshgroup siril && usermod -aG sudo siril
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create siril directory in home
RUN mkdir -p /home/siril/.ssh

# Copy the ssh public key in the authorized_keys file. The idkey.pub below is a public key file you get from ssh-keygen. They are under ~/.ssh directory by default.
COPY id_rsa.pub /home/siril/.ssh/authorized_keys
COPY setup-devcloud-access-172990.sh /home/siril/.

COPY emacs_settings/emacs /home/siril/.emacs
RUN mkdir -p /home/siril/.emacs.d/lisp
COPY emacs_settings/etags-* /home/siril/.emacs.d/lisp/.
RUN chown -R siril:sshgroup /home/siril/.emacs.d /home/siril/.emacs

# change ownership of the key file. 
RUN chown -R siril:sshgroup /home/siril/.ssh && chmod 600 /home/siril/.ssh/authorized_keys && chown siril:sshgroup /home/siril/setup-devcloud-access-172990.sh

# Start SSH service
RUN service ssh start

# Expose docker port 22
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]