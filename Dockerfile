# Generated originally via:
# docker pull sflow/sflow-rt >/dev/null && docker images | grep sflow/sflow-rt | head -n1 | \
#   awk '{print $3}' | xargs docker run -v /var/run/docker.sock:/var/run/docker.sock --rm chenzj/dfimage

FROM sflow/sflow-rt:latest
ADD file:4583e12bf5caec40b861a3409f2a1624c3f3556cc457edb99c9707f00e779e45 in /
CMD ["/bin/sh"]
RUN /bin/sh -c apk --update add openjdk8-jre curl  \
    && curl -sLOk http://www.inmon.com/products/sFlow-RT/sflow-rt.tar.gz  \
    && tar -xzf sflow-rt.tar.gz  \
    && rm sflow-rt.tar.gz  \
    && addgroup -S sflowrt  \
    && adduser -S -h /sflow-rt -g sFlow-RT -G sflowrt -s /sbin/nologin sflowrt  \
    && chown -R sflowrt:sflowrt sflow-rt
EXPOSE 6343/udp 8008
USER sflowrt
WORKDIR /sflow-rt
ENV RTMEM=1G LANG=en_US.UTF-8
HEALTHCHECK &{["CMD-SHELL" "curl -sf http://localhost:8008/version || exit 1"] "0s" "0s" "0s" '\x00'}
CMD ["/sflow-rt/start.sh"]
