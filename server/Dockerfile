FROM rocker/tidyverse:4.2.0

COPY ./start.sh .
RUN chmod +x start.sh

RUN apt-get -y update
RUN apt-get install -y libnss-wrapper  gettext vim

RUN apt-get install -y libudunits2-dev libgdal-dev libgeos-dev libproj-dev

# rstudio needs write permissions to sqlite
RUN chgrp -R 0 /var/lib/rstudio-server/ && \
    chmod -R g=u /var/lib/rstudio-server/ && \
    chown .root -R /home && \
    chmod g+w -R /home && \
    echo 'r-libs-user=~/R/library' >>/etc/rstudio/rsession.conf && \
    echo "R_LIBS=\${R_LIBS-'/home/rstudio-server/R/library'}" >/usr/local/lib/R/etc/Renviron.site
######
ENV PKG_SHINY_VERSION=1.5.7.907

ADD https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-${PKG_SHINY_VERSION}-amd64.deb /tmp/shiny.deb
RUN dpkg -i /tmp/shiny.deb && \
    install2.r -e shiny rmarkdown shinythemes shinydashboard && \
    mv /srv/shiny-server/ /srv/shiny-server.old/ && \
    mkdir -p /srv/shiny-server/ && \
    mkdir -p /var/log/shiny-server && \
    chown rstudio.rstudio /var/log/shiny-server && \
    chmod go+w -R /var/log/shiny-server /usr/local/lib/R /srv /var/lib/shiny-server &&\
    mkdir -p /var/log/rstudio-server &&\
    chown rstudio.rstudio /var/log/rstudio-server &&\
    chmod go+w /var/log/rstudio-server

COPY shiny-server.conf /etc/shiny-server/
###

ENTRYPOINT ["/start.sh"]
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize", "0"]
