FROM centos:7

RUN yum update -y && \
  yum install -y epel-release && \
  yum install -y https://centos7.iuscommunity.org/ius-release.rpm && \
  yum install -y python36u && \
  rm -f /usr/bin/python && \
  ln -s /usr/bin/python3.6 /usr/bin/python && \
  python -m ensurepip && \
  ln -s /usr/bin/pip3 /usr/bin/pip && \
  pip install --upgrade pip && \
  pip install awscli
