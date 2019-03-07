# hello-go-deploy-gce Dockerfile used to build docker image on concourse ci

FROM alpine

MAINTAINER Jeff DeCola (https://github.com/JeffDeCola/hello-go-deploy-gce)

# Put the binary into the container
COPY hello-go-deploy-gce /

# Add the ailibty to /bin/bash
RUN apk add --update bash && rm -rf /var/cache/apk/*

# Runs the binary when someone uses it.
CMD /hello-go-deploy-gce