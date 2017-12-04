FROM debian:latest

MAINTAINER timokli


RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get dist-upgrade
RUN apt-get install dirmngr lighttpd git libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 libusb-1.0.0:i386 tcl curl psmisc socat

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu zesty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu zesty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

RUN apt-get update
RUN apt-get install oracle-java9-installer

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
RUN cp /opt/occu-git/WebUI/www/* -R /www/
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

USER root

ADD image/run.sh /root/run.sh

# Run container
EXPOSE 8081
CMD ["/root/run.sh"]
