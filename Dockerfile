FROM debian:stretch

MAINTAINER timokli

# Set environment variables
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install dependencies and tools
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install apt-utils apt-transport-https
RUN apt-get -y install curl wget gnupg2
RUN apt-get -y install nano vim

RUN wget -q -O - https://www.debmatic.de/debmatic/public.key | apt-key add -
RUN bash -c 'echo "deb https://www.debmatic.de/debmatic stable main" > /etc/apt/sources.list.d/debmatic.list'

RUN apt-get -y update
RUN apt-get -y install linux-headers-generic
#RUN apt-get -y install linux-headers-$(uname -r)
RUN apt-get -y install pivccu-modules-dkms

RUN reboot

# Install latest Debmatic
RUN apt-get -y install debmatic

# Run container
USER root
ADD image/run.sh /root/run.sh
EXPOSE 80
CMD ["/root/run.sh"]
