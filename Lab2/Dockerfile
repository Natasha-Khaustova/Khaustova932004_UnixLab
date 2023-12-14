FROM ubuntu:latest

VOLUME /var/lib/docker/volumes/my_volume/flock

WORKDIR /var/lib/docker/volumes/my_volume/flock

COPY dockerLab.sh /dockerLab.sh

RUN chmod +x /dockerLab.sh

CMD ["/dockerLab.sh"]
