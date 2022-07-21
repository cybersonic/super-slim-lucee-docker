FROM alpine as base
ARG LUCEE_VERSION="5.3.10.28-SNAPSHOT"
ADD https://cdn.lucee.org/lucee-express-${LUCEE_VERSION}.zip lucee.zip
ADD https://cdn.lucee.org/lucee-light-${LUCEE_VERSION}.jar lucee-light.jar
RUN mkdir /lucee && \
     unzip lucee.zip -d /lucee && \
     chmod +x /lucee/*.sh && \
     chmod +x /lucee/bin/*.sh && \
     rm -f lucee.zip && \
     rm -f /lucee/lib/ext/lucee.jar && \
     mv lucee-light.jar /lucee/lib/ext/lucee.jar && \
     rm -rf /lucee/__MACOSX
COPY webroot /lucee/webapps/ROOT

FROM alpine
RUN apk add openjdk11-jre
COPY --from=base /lucee /lucee
RUN LUCEE_ENABLE_WARMUP=true /lucee/startup.sh
ENTRYPOINT [ "/lucee/startup.sh" ]

