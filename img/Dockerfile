FROM alpine:3.6
RUN apk add --no-cache openssh-server tor s6
RUN adduser -u 1000 -D user && mkdir /home/user/.ssh
COPY client_key.pub /home/user/.ssh/authorized_keys
RUN chown -R user:user /home/user/.ssh && \
    chmod 700 /home/user/.ssh && \
    chmod 600 /home/user/.ssh/authorized_keys
COPY sshd_config /etc/ssh/sshd_config
COPY entry.sh /entry.sh
COPY torrc.tpl /etc/tor/torrc.tpl
ENV TOR_PORT 9999
ENTRYPOINT [ "/entry.sh" ]
CMD [ "/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config" ]