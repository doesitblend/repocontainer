FROM local:centos7

RUN systemctl mask getty@tty1
RUN yum install -y httpd httpd-tools
RUN yum install -y createrepo zip unzip yum-utils
COPY ./awscliv2.zip /root/
RUN unzip -o /root/awscliv2.zip -d /root/
RUN /root/aws/install
RUN /usr/local/bin/aws --no-sign-request --endpoint-url https://s3.repo.saltstack.com s3 sync s3://s3/py3/redhat/7/ /var/www/html/py3/redhat/7/
RUN yumdownloader --downloadonly --downloaddir=/var/www/html/py3/redhat/7/x86_64/latest/ systemd systemd-libs systemd-python
RUN rm -fRv /var/www/html/py3/redhat/7/x86_64/latest/repodata
RUN createrepo /var/www/html/py3/redhat/7/x86_64/latest/
RUN /bin/createrepo /var/www/html
RUN systemctl enable httpd
EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/init"]
