FROM centos:7

LABEL maintainer="Jaroslav Stolyarenko"

RUN yum install \
  epel-release \
  python-pip \
  ansible \
  python-devel \
  krb5-devel \
  krb5-libs \
  krb5-workstation
  
RUN pip install \
  pywinrm \
  pywinrm[kerberos] \
  netaddr \
  Jinja2==2.10
 
ENTRYPOINT ["ansible-playbook"]
