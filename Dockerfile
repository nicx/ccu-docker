FROM debian:stretch

MAINTAINER timokli

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install dirmngr lighttpd git libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 libusb-1.0.0:i386 tcl curl psmisc socat systemd

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu zesty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu zesty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

RUN echo "oracle-java9-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "oracle-java9-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

RUN apt-get -y update
RUN apt-get -y install oracle-java9-installer

RUN mkdir /opt/occu-git/
RUN mkdir /opt/HMServer/
RUN mkdir /firmware/
RUN mkdir /opt/hm/
RUN mkdir /opt/HmIP/
RUN mkdir /www/
RUN mkdir /etc/config/
RUN mkdir /etc/config_templates/
RUN mkdir /opt/hm/etc/
RUN mkdir /etc/config/rfd/
RUN mkdir /var/status/
RUN mkdir /etc/config/hs485d/
RUN mkdir /etc/config/addons/
RUN mkdir /www/addons/
RUN mkdir /etc/config/rc.d/

RUN git clone https://github.com/eq-3/occu.git /opt/occu-git/

RUN rm /etc/lighttpd/* -R

RUN cp /opt/occu-git/HMserver/opt/HMServer/HMIPServer.jar /opt/HMServer/
RUN cp /opt/occu-git/HMserver/opt/HMServer/HMServer.jar /opt/HMServer/
RUN cp /opt/occu-git/WebUI/bin/* -R /bin/
RUN cp /opt/occu-git/WebUI/www/* -R /www/; exit 0
RUN cp /opt/occu-git/firmware/* -R /firmware/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/HS485D/bin/* -R /bin/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/HS485D/lib/* -R /lib/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/LinuxBasis/* -R /
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/RFD/bin/* -R /bin/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/RFD/lib/* -R /lib/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/RFD/www/config/* -R /www/config/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/bin/* -R /bin/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/lib/* -R /lib/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/RFD/opt/HmIP/* -R /opt/HmIP/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages/lighttpd/etc/lighttpd/* -R /etc/lighttpd/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/config/* -R /etc/config/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/rega.conf /etc/config/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/config_templates/* -R /etc/config_templates/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/crRFD.conf /etc/config/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config/* -R /etc/config/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/* -R /etc/config_templates/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages/lighttpd/lib/* -R /lib/
RUN cp /opt/occu-git/HMserver/etc/config_templates/log4j.xml /etc/config/
RUN cp /opt/occu-git/HMserver/opt/HMServer/* -R /opt/HMServer/
RUN cp /opt/occu-git/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/crRFD.conf /etc/crRFD.conf

RUN chmod 777 /bin/hs485dLoader
RUN chmod 777 /bin/ReGaHss
RUN chmod 777 /bin/rfd

RUN ln -s /bin/ /opt/hm/bin
RUN ln -s /www/ /opt/hm/www
RUN ln -s /etc/config/ /usr/local/etc/config
RUN ln -s /etc/config/ /opt/hm/etc/config
RUN ln -s /firmware/ /opt/hm/firmware
RUN ln -s /lib/ /opt/hm/
RUN ln -s /etc/config/ /opt/hm/etc/config
RUN ln -s /firmware/ /etc/config
RUN ln -s /etc/crRFD.conf /opt/hm/etc/crRFD.conf
RUN ln -s /etc/config/rega.conf /opt/hm/etc/rega.conf
RUN ln -s /etc/config_templates/ /opt/hm/etc/config_templates
RUN ln -s /www/addons/ /etc/config/addons/www
RUN ln -s /www/addons/ /usr/local/addons

RUN touch /var/status/SDmounted
RUN touch /var/status/SDinitialised
RUN touch /var/status/hasLink
RUN touch /var/status/hasIP
RUN touch /var/status/hasInternet
RUN touch /var/status/hasNTP
RUN touch /var/status/HMServerStarted

RUN echo "BidCoS-Address=0x123456" >> /var/ids
RUN echo "SerialNumber=KEQ0111111" >> /var/ids

RUN echo "LOGHOST=/var/log/" >> /etc/config/syslog
RUN echo "LOGLEVEL_RFD=1" >> /etc/config/syslog
RUN echo "LOGLEVEL_HS485D=1" >> /etc/config/syslog
RUN echo "LOGLEVEL_REGA=0" >> /etc/config/syslog

RUN echo "VERSION=2.29.22" >> /boot/VERSION

RUN echo "CP_DEVCONFIG=1" >> /opt/hm/etc/config/tweaks

RUN sed -i "s|8183|8181|g" /etc/config/rega.conf
RUN sed -i "s|8183|8181|g" /etc/lighttpd/conf.d/proxy.conf

RUN sed -i "s|\[Interface 0\]|#\[Interface 0\]|g" /etc/config/rfd.conf
RUN sed -i "s|Type|#Type|g" /etc/config/rfd.conf
RUN sed -i "s|ComPortFile = /dev/ttyAPP0|#ComPortFile = /dev/ttyAPP0|g" /etc/config/rfd.conf
RUN sed -i "s|AccessFile = /dev/null|#AccessFile = /dev/null|g" /etc/config/rfd.conf
RUN sed -i "s|ResetFile = /dev/ccu2-ic200|#ResetFile = /dev/ccu2-ic200|g" /etc/config/rfd.conf

RUN rm /usr/local/etc/config/config

RUN sed -i "s|set iso8601_date \[exec date -Iseconds\]|set iso8601_date \[exec date +%Y-%m-%dT%H:%M:%S%z\]|g" /www/config/cp_security.cgi
RUN sed -i "s|exec tar czf /tmp/usr_local.tar.gz|exec tar czfh /tmp/usr_local.tar.gz|g" /www/config/cp_security.cgi
RUN sed -i "s|exec tar xzf /tmp/usr_local.tar.gz|exec tar xzfh /tmp/usr_local.tar.gz|g" /www/config/cp_security.cgi
RUN sed -i "s|exec umount /usr/local||g" /www/config/cp_security.cgi
RUN sed -i "s|/usr/sbin/ubidetach -p /dev/mtd6||g" /www/config/cp_security.cgi
RUN sed -i "s|/usr/sbin/ubiformat /dev/mtd6 -y||g" /www/config/cp_security.cgi
RUN sed -i "s|/usr/sbin/ubiattach -p /dev/mtd6||g" /www/config/cp_security.cgi
RUN sed -i "s|/usr/sbin/ubimkvol /dev/ubi1 -N user -m||g" /www/config/cp_security.cgi
RUN sed -i "s|mount /usr/local||g" /www/config/cp_security.cgi
RUN sed -i "s|mount -o remount,ro /usr/local||g" /www/config/cp_security.cgi
RUN sed -i "s|mount -o remount,rw /usr/local||g" /www/config/cp_security.cgi

USER root

ADD image/start.sh /opt/start.sh
RUN chmod 777 /opt/start.sh

ADD image/ccu /etc/init.d/ccu
RUN chmod 777 /etc/init.d/ccu
RUN systemctl enable ccu

# Run container
EXPOSE 80
CMD ["/opt/start.sh"]
