# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>
#
# Enriched by patterns found at https://github.com/openshift/postgresql/blob/master/9.4/Dockerfile.rhel7 by
#   Christoph Görn <goern@redhat.com>

FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

# Labels consumed by Red Hat build service
LABEL Component="nginx" \
      Name="centos/nginx-180-centos7" \
      Version="1.8.0" \
      Release="1"

# Labels could be consumed by OpenShift
LABEL io.k8s.description="nginx [engine x] is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server, originally written by Igor Sysoev." \
      io.k8s.display-name="nginx 1.8.0" \
      io.openshift.expose-services="80:http" \
      io.openshift.tags="nginx"

RUN yum -y install --setopt=tsflags=nodocs centos-release-scl-rh && \
    yum -y update --setopt=tsflags=nodocs && \
    yum -y install --setopt=tsflags=nodocs scl-utils rh-nginx18 gettext && \
    yum clean all 

# Get prefix path and path to scripts rather than hard-code them in scripts
ENV CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/nginx \
ENABLED_COLLECTIONS=rh-nginx18

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ENV BASH_ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
    ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
    PROMPT_COMMAND=". ${CONTAINER_SCRIPTS_PATH}/scl_enable"

ADD root /

RUN mkdir -p /app /etc/nginx/ && \
    fix-permissions /var/opt/rh/rh-nginx18/ && \
    fix-permissions /app && \
    fix-permissions /etc/nginx/

EXPOSE 80

ENV NGINX_FASTCGI_PASS 127.0.0.1

ENTRYPOINT ["container-entrypoint"]
CMD [ "nginx18" ]
