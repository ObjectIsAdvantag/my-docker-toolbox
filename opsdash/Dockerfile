FROM centos:latest

MAINTAINER "Steve Sfartz" <steve.sfartz@gmail.com>

WORKDIR /tmp
ADD . /tmp

RUN yum install -y opsdash-server-1.6.2-1.x86_64.rpm
RUN cp *.lic /etc/opsdash/ 

# logs are generated at /var/log/opsdash

EXPOSE 8080 6273
CMD ["opsdash-server"]

