FROM centos:7

LABEL maintainer="Jaroslav Stolyarenko"

RUN yum install -y epel-release && \
  yum install -y \
    PyYAML \
    python-jinja2 \
    python-httplib2 \
    python-keyczar \
    python-paramiko \
    python-setuptools \
    git \
    gcc \
    python-pip \
    python-devel \
    krb5-devel \
    krb5-libs \
    krb5-workstation && \
  yum clean all

RUN mkdir /etc/ansible/
RUN echo -e '[local]\nlocalhost' > /etc/ansible/hosts

RUN pip install \
  ansible \
  pywinrm[kerberos] \
  netaddr 
 
ENTRYPOINT ["ansible-playbook"]
