FROM centos:centos6

MAINTAINER nktn

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    yum update -y && \
    yum -y install passwd openssh openssh-clients openssh-server sudo rsync && \
    yum clean all && \
    useradd docker && \
    passwd -f -u docker && \
    mkdir -p /home/docker/.ssh && \
    chown docker /home/docker/.ssh && \
    chmod 700 /home/docker/.ssh
ADD authorized_keys /home/docker/.ssh/
RUN chown docker /home/docker/.ssh/authorized_keys && \
    chmod 600 /home/docker/.ssh/authorized_keys && \
    echo "docker ALL=(ALL) ALL" >> /etc/sudoers.d/docker && \
    sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    /etc/init.d/sshd start && \
    /etc/init.d/sshd stop
CMD /usr/sbin/sshd -D