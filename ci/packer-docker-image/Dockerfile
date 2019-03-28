# hello-go-deploy-gce Dockerfile used to build docker image

FROM golang:1.10.3

LABEL Jeff DeCola (https://github.com/JeffDeCola/hello-go-deploy-gce-packer-image)

# Add the ailibty to /bin/bash
RUN apk add --update bash && rm -rf /var/cache/apk/*

# ADD PACKER
RUN wget wget https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_linux_amd64.zip
RUN unzip packer_1.3.5_linux_amd64.zip
RUN sudo mv packer /usr/local/
RUN echo 'export PATH="$PATH:/usr/local/packer"' >> /root/.bashrc
