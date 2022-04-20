#!/bin/sh

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
cp /etc/passwd /tmp/passwd

#sed -i '/^rstudio-server:/d' passwd
#sed -i "s/^rstudio-server:x:\([0-9]*\):/rstudio-server:x:$(id -u):/" /tmp/passwd
sed -i "s/^rstudio-server:x:\([0-9]*\):/rstudio-server:x:$(id -u):/" /tmp/passwd
#sed -i "s/^rstudio:x:\([0-9]*\):/rstudio:x:$(id -u):/" /tmp/passwd

#envsubst < ${HOME}/passwd.template > /tmp/passwd
export LD_PRELOAD=/usr/lib/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

# rstudio expects this for correct cookie creation
# can this be done in any other way?
export USER=rstudio-server

if [ ! -f '/srv/shiny-server/index.html' ];
then
    echo "Copying examples:"
    echo " from /opt/shiny-server.old/ to /srv/shiny-server/"
    cp -r /srv/shiny-server.old/* /srv/shiny-server/
else
    echo "index.html exists"
fi

exec $@
