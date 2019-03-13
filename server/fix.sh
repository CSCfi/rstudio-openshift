#!/bin/bash

tempfile=$(mktemp)
sed -e "s/^rstudio.*//g" /etc/passwd > $tempfile
cp $tempfile /etc/passwd
rm -f $tempfile
echo "rstudio-server:x:$(id -u):$(id -g)::/home/rstudio:" >> /etc/passwd
echo "rstudio:x:$(id -u):$(id -g)::/home/rstudio:" >> /etc/passwd

tempfile2=$(mktemp)
sed -e "s/^rstudio.*//g" /etc/group > $tempfile2
cp $tempfile2 /etc/group
rm -f $tempfile2
echo "rstudio:x:$(id -u):" >> /etc/group

echo "rstudio-server:$6$OLWwdiLp$uLstyoh.dp5yAWgZqoHUj707hxKlca17PrGFoDKvOlX.QHJVdLBm3eBfG9JF0NKjgxCL8QKTl3xMR/LZJSmgR1:17652:0:99999:7:::" >> /etc/shadow