FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y bash && \
    rm -rf /var/lib/apt/lists/*

COPY dockerLab.sh /dockerLab.sh
RUN chmod +x /dockerLab.sh

CMD ["/dockerLab.sh"]