FROM amazeeio/centos:7
MAINTAINER amazee.io

RUN yum install -y epel-release && \ 
    yum install -y \
        nginx && \
    yum clean all

COPY container-entrypoint /usr/sbin/container-entrypoint

COPY nginx.conf /etc/nginx/nginx.conf

COPY sites/www.conf /etc/nginx/sites/www.conf

RUN mkdir -p /app && \
    fix-permissions /app && \
    fix-permissions /etc/nginx/ && \
    fix-permissions /var/log/nginx/ && \
    fix-permissions /var/lib/nginx/ && \
    fix-permissions /run/

EXPOSE 8080

ENTRYPOINT ["container-entrypoint"]
CMD [ "nginx" ]
