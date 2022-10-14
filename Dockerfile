FROM ubuntu:latest
RUN apt update && apt install  openssh-server sudo emacs build-essential default-jdk default-jre cmake -y

# Create a user “siril” and group “sshgroup”
RUN groupadd sshgroup && useradd -ms /bin/bash -g sshgroup siril && usermod -aG sudo siril
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create siril directory in home
RUN mkdir -p /home/siril/.ssh

# Copy the ssh public key in the authorized_keys file. The idkey.pub below is a public key file you get from ssh-keygen. They are under ~/.ssh directory by default.
COPY id_rsa.pub /home/siril/.ssh/authorized_keys

# change ownership of the key file. 
RUN chown siril:sshgroup /home/siril/.ssh/authorized_keys && chmod 600 /home/siril/.ssh/authorized_keys

# Start SSH service
RUN service ssh start

# Expose docker port 22
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]