# Upstream Dockerfile https://github.com/rocker-org/rocker-versioned/blob/master/tidyverse/3.4.4/Dockerfile
FROM rocker/tidyverse:4.0.2

RUN apt-get update && apt-get install --no-install-recommends -y \
    nano \
    libcurl4-openssl-dev \
    openssh-client \
    less \
    htop \
    procps \
    net-tools \
    rsync \
    gdebi-core \
    libxt-dev \
    man-db && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup various variables
ENV TZ="Europe/Helsinki" \
    HOME="/mnt/${NAME}-pvc" \
    TINI_VERSION=v0.18.0 \
    APP_UID=999 \
    APP_GID=999 \
    PKG_R_VERSION=3.4.4 \
    PKG_RSTUDIO_VERSION=1.1.447 \
    PKG_SHINY_VERSION=1.5.7.907

# Setup Tini, as S6 does not work when run as non-root users
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

# Setup Shiny
ADD https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-${PKG_SHINY_VERSION}-amd64.deb /tmp/shiny.deb
RUN gdebi -n /tmp/shiny.deb && \
    rm /tmp/shiny.deb && \
    install2.r -e shiny rmarkdown shinythemes shinydashboard && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    mkdir -p /var/log/shiny-server && \
    chown rstudio.rstudio /var/log/shiny-server && \
    chmod go+w -R /var/log/shiny-server /usr/local/lib/R /srv /var/lib/shiny-server


COPY rserver.conf rsession.conf /etc/rstudio/
COPY start.sh /usr/local/bin/start.sh
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY .Renviron $HOME/.Renviron

#OpenShift additions
RUN if [ "$USERNAME" != "rstudio" ] ; then useradd -m $USERNAME ; fi

RUN chmod a+x /usr/local/bin/start.sh

RUN chmod go+w -R $HOME && \
    usermod -u 988 rstudio-server && \
    groupmod -g 988 rstudio-server && \
    usermod -u "$APP_UID" "$USERNAME" && \
    groupmod -g "$APP_GID" "$USERNAME" && \
    chmod -R go+w /tmp/downloaded_packages /etc/rstudio/rsession.conf

RUN chgrp root -R /usr/local/lib/R/site-library

COPY fix.sh /usr/local/bin/fix.sh
RUN chmod ug+rw /etc/passwd
RUN chmod ug+rw /etc/group

RUN chgrp root /etc/shadow

RUN chmod ug+rw /etc/shadow

RUN chgrp root /usr/local/bin/fix.sh \
    && chmod 774 /usr/local/bin/fix.sh


USER $APP_UID:$APP_GID
WORKDIR $HOME
EXPOSE 8787 3838
#MAINTAINER
ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["/usr/local/bin/start.sh"]
