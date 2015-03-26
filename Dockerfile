# This Dockerfile is a CentOS 7 based Jenkins slave build node with git, pip, and nose
FROM centos:centos7
MAINTAINER Jordan Starcher <jstarcher@gmail.com>

# Add EPEL, make sure the package repository is up to date.
RUN rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum -y update
RUN yum clean all

# Install a basic SSH server
RUN yum install -y openssh-server
RUN sed 's/UsePrivilegeSeparation yes/UsePrivilegeSeparation no/' -i /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd
RUN /usr/bin/ssh-keygen -A

# Install JDK 7 (latest edition)
RUN yum install -y java-1.7.0-openjdk

# Install git
RUN yum install -y git

# Install pip and nose
RUN yum -y install python-pip
RUN pip install nose


# Add user jenkins to the image
RUN adduser jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd
# Add sudo
RUN yum install -y sudo
# Allow passwordless sudo
RUN echo "jenkins   ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/jenkins
RUN sed -ri 's/Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
