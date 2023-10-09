FROM  ubuntu:latest
WORKDIR /var/subsonic/
COPY ./subsonic-6.1.6.deb /tmp/.
COPY ./startup.sh /startup.sh
RUN apt update -y
RUN apt install openjdk-8-jre -y
RUN dpkg -i /tmp/subsonic-6.1.6.deb
RUN mkdir /var/music /var/movie
EXPOSE 4040
CMD ["/startup.sh"]
