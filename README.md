# HELLO GO DEPLOY GCE

[![Tag Latest](https://img.shields.io/github/v/tag/jeffdecola/hello-go-deploy-gce)](https://github.com/JeffDeCola/hello-go-deploy-gce/tags)
[![Go Reference](https://pkg.go.dev/badge/github.com/JeffDeCola/hello-go-deploy-gce.svg)](https://pkg.go.dev/github.com/JeffDeCola/hello-go-deploy-gce)
[![Go Report Card](https://goreportcard.com/badge/github.com/JeffDeCola/hello-go-deploy-gce)](https://goreportcard.com/report/github.com/JeffDeCola/hello-go-deploy-gce)
[![codeclimate Maintainability](https://api.codeclimate.com/v1/badges/1dff96727b972dd4cda4/maintainability)](https://codeclimate.com/github/JeffDeCola/hello-go-deploy-gce/maintainability)
[![codeclimate Issue Count](https://codeclimate.com/github/JeffDeCola/hello-go-deploy-gce/badges/issue_count.svg)](https://codeclimate.com/github/JeffDeCola/hello-go-deploy-gce/issues)
[![Docker Pulls](https://badgen.net/docker/pulls/jeffdecola/hello-go-deploy-gce?icon=docker&label=pulls)](https://hub.docker.com/r/jeffdecola/hello-go-deploy-gce/)
[![MIT License](http://img.shields.io/:license-mit-blue.svg)](http://jeffdecola.mit-license.org)
[![jeffdecola.com](https://img.shields.io/badge/website-jeffdecola.com-blue)](https://jeffdecola.com)

_Deploy a "hello-world" docker image to
Google Compute Engine (gce)._

Other Services

* PaaS
  * [hello-go-deploy-aws-elastic-beanstalk](https://github.com/JeffDeCola/hello-go-deploy-aws-elastic-beanstalk)
  * [hello-go-deploy-azure-app-service](https://github.com/JeffDeCola/hello-go-deploy-azure-app-service)
  * [hello-go-deploy-gae](https://github.com/JeffDeCola/hello-go-deploy-gae)
  * [hello-go-deploy-marathon](https://github.com/JeffDeCola/hello-go-deploy-marathon)
* CaaS
  * [hello-go-deploy-amazon-ecs](https://github.com/JeffDeCola/hello-go-deploy-amazon-ecs)
  * [hello-go-deploy-amazon-eks](https://github.com/JeffDeCola/hello-go-deploy-amazon-eks)
  * [hello-go-deploy-aks](https://github.com/JeffDeCola/hello-go-deploy-aks)
  * [hello-go-deploy-gke](https://github.com/JeffDeCola/hello-go-deploy-gke)
* IaaS
  * [hello-go-deploy-amazon-ec2](https://github.com/JeffDeCola/hello-go-deploy-amazon-ec2)
  * [hello-go-deploy-azure-vm](https://github.com/JeffDeCola/hello-go-deploy-azure-vm)
  * [hello-go-deploy-gce](https://github.com/JeffDeCola/hello-go-deploy-gce)
    **(You are here)**

Table of Contents

* [OVERVIEW](https://github.com/JeffDeCola/hello-go-deploy-gce#overview)
* [PREREQUISITES](https://github.com/JeffDeCola/hello-go-deploy-gce#prerequisites)
* [SOFTWARE STACK](https://github.com/JeffDeCola/hello-go-deploy-gce#software-stack)
* [RUN](https://github.com/JeffDeCola/hello-go-deploy-gce#run)
* [STEP 1 - TEST](https://github.com/JeffDeCola/hello-go-deploy-gce#step-1---test)
* [STEP 2 - BUILD (DOCKER IMAGE VIA DOCKERFILE)](https://github.com/JeffDeCola/hello-go-deploy-gce#step-2---build-docker-image-via-dockerfile)
* [STEP 3 - PUSH (TO DOCKERHUB)](https://github.com/JeffDeCola/hello-go-deploy-gce#step-3---push-to-dockerhub)
* [STEP 4 - DEPLOY (TO GCE)](https://github.com/JeffDeCola/hello-go-deploy-gce#step-4---deploy-to-gce)
  * [STEP 4.1 BUILD A CUSTOM MACHINE IMAGE USING PACKER](https://github.com/JeffDeCola/hello-go-deploy-gce#step-41-build-a-custom-machine-image-using-packer)
  * [STEP 4.2 CREATE AN INSTANCE TEMPLATE](https://github.com/JeffDeCola/hello-go-deploy-gce#step-42-create-an-instance-template)
  * [STEP 4.3 CREATE AN INSTANCE GROUP](https://github.com/JeffDeCola/hello-go-deploy-gce#step-43-create-an-instance-group)
* [CHECK SERVICES ARE RUNNING](https://github.com/JeffDeCola/hello-go-deploy-gce#check-services-are-running)
* [CONTINUOUS INTEGRATION & DEPLOYMENT](https://github.com/JeffDeCola/hello-go-deploy-gce#continuous-integration--deployment)

Documentation and Reference

* [jeffs-gce-image-ubuntu-2204](https://github.com/JeffDeCola/my-packer-image-builds/tree/master/google-compute-engine-images/jeffs-gce-image-ubuntu-2204)
  is where I build the gce image
* The
  [hello-go-deploy-gce docker image](https://hub.docker.com/r/jeffdecola/hello-go-deploy-gce)
  on dockerhub
* My
  [gce cheat sheet](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/service-architectures/infrastructure-as-a-service/google-compute-engine-cheat-sheet)
  for more detailed information and illustrations
* This repos
  [github webpage](https://jeffdecola.github.io/hello-go-deploy-gce/)
  _built with
  [concourse](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/ci-README.md)_

## OVERVIEW

Every 2 seconds this App will print,

```txt
    INFO[0000] Let's Start this!
    Hello everyone, count is: 1
    Hello everyone, count is: 2
    Hello everyone, count is: 3
    etc...
```

## PREREQUISITES

You will need the following go packages,

```bash
go get -u -v github.com/sirupsen/logrus
go get -u -v github.com/cweill/gotests/...
```

This repo contains the packer gce image build scripts,

```bash
git clone git@github.com:JeffDeCola/my-packer-image-builds.git
```

## SOFTWARE STACK

* DEVELOPMENT
  * [go](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/development/languages/go-cheat-sheet)
* OPERATIONS
  * [concourse/fly](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations/continuous-integration-continuous-deployment/concourse-cheat-sheet)
    (optional)
  * [docker](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations/orchestration/builds-deployment-containers/docker-cheat-sheet)
  * [packer](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations/orchestration/builds-deployment-containers/packer-cheat-sheet)
* SERVICES
  * [dockerhub](https://hub.docker.com/)
  * [google compute engine (gce)](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/service-architectures/infrastructure-as-a-service/google-compute-engine-cheat-sheet)

## RUN

To
[run.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/hello-go-deploy-gce-code/run.sh),

```bash
cd hello-go-deploy-gce-code
go run main.go
```

To
[create-binary.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/hello-go-deploy-gce-code/bin/create-binary.sh),

```bash
cd hello-go-deploy-gce-code/bin
go build -o hello-go ../main.go
./hello-go
```

This binary will not be used during a docker build
since it creates it's own.

## STEP 1 - TEST

To create unit `_test` files,

```bash
cd hello-go-deploy-gce-code
gotests -w -all main.go
```

To run
[unit-tests.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/hello-go-deploy-gce-code/test/unit-tests.sh),

```bash
go test -cover ./... | tee test/test_coverage.txt
cat test/test_coverage.txt
```

## STEP 2 - BUILD (DOCKER IMAGE VIA DOCKERFILE)

This docker image is built in two stages.
In **stage 1**, rather than copy a binary into a docker image (because
that can cause issues), the Dockerfile will build the binary in the
docker image.
In **stage 2**, the Dockerfile will copy this binary
and place it into a smaller docker image based
on `alpine`, which is around 13MB.

To
[build.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/hello-go-deploy-gce-code/build/build.sh)
with a
[Dockerfile](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/hello-go-deploy-gce-code/build/Dockerfile),

```bash
cd hello-go-deploy-gce-code/build
docker build -f Dockerfile -t jeffdecola/hello-go-deploy-gce .
```

You can check and test this docker image,

```bash
docker images jeffdecola/hello-go-deploy-gce
docker run --name hello-go-deploy-gce -dit jeffdecola/hello-go-deploy-gce
docker exec -i -t hello-go-deploy-gce /bin/bash
docker logs hello-go-deploy-gce
docker rm -f hello-go-deploy-gce
```

## STEP 3 - PUSH (TO DOCKERHUB)

You must be logged in to DockerHub,

```bash
docker login
```

To
[push.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/hello-go-deploy-gce-code/push/push.sh),

```bash
docker push jeffdecola/hello-go-deploy-gce
```

Check the
[hello-go-deploy-gce docker image](https://hub.docker.com/r/jeffdecola/hello-go-deploy-gce)
at DockerHub.

## STEP 4 - DEPLOY (TO GCE)

There are three steps to deploy on gce,

* STEP 4.1 - Build a gce image
* STEP 4.2 - Create an instance template (HW resources)
* STEP 4.3 - Create an instance group (Launch VM in region)

For this example, I will add two running services,

* The dockerhub image runs at boot
  [hello-go-deploy-gce](https://hub.docker.com/r/jeffdecola/hello-go-deploy-gce/)
* A binary /root/bin/hello-go executable runs at boot

To keep things simple, the files are located in my
[my-packer-image-builds](https://github.com/JeffDeCola/my-packer-image-builds)
repo.

### STEP 4.1 BUILD A CUSTOM MACHINE IMAGE USING PACKER

You will need to set the following environment variables (I added mine in ~/.bashrc),

```bash
export GCP_JEFFS_SERVICE_ACCOUNT_PATH=[path to your google platform .json file]
export GCP_JEFFS_PROJECT_ID=[your project id]
```

To validate your packer template file
[template.pkr.hcl](https://github.com/JeffDeCola/my-packer-image-builds/blob/master/google-compute-engine-images/jeffs-gce-image-ubuntu-2204/template.pkr.hcl),

```bash
cd my-packer-image-builds/google-compute-engine-images/jeffs-gce-image-ubuntu-2204
packer validate \
    -var "image_name=hello-go-deploy-gce" \
    -var "account_file=$GCP_JEFFS_SERVICE_ACCOUNT_PATH" \
    -var "project_id=$GCP_JEFFS_PROJECT_ID" \
    template.pkr.hcl
```

To
[build-image.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/hello-go-deploy-gce-code/deploy/build-image.sh)
on gce,

```bash
cd my-packer-image-builds/google-compute-engine-images/jeffs-gce-image-ubuntu-2204
packer build \
    -var "image_name=hello-go-deploy-gce" \
    -var "account_file=$GCP_JEFFS_SERVICE_ACCOUNT_PATH" \
    -var "project_id=$GCP_JEFFS_PROJECT_ID" \
    template.pkr.hcl
```

Check that the image was created at gce,

```bash
gcloud config set project $GCP_JEFFS_PROJECT_ID
gcloud compute images list --no-standard-images
```

### STEP 4.2 CREATE AN INSTANCE TEMPLATE

The instance template contains the HW resources the instance group needs
to create the VM instance.

To
[create-instance-template](https://github.com/JeffDeCola/my-packer-image-builds/blob/master/google-compute-engine-images/jeffs-gce-image-ubuntu-2204/create-instance-template.sh),

```bash
cd my-packer-image-builds/google-compute-engine-images/jeffs-gce-image-ubuntu-2204
sh create-instance-template.sh "jeffs-hello-go-deploy-gce-image" "hello-go-deploy-gce"
```

Check the instance template was created,

```bash
gcloud compute instance-templates list
```

### STEP 4.3 CREATE AN INSTANCE GROUP

The instance group controls the show.
It launches and scales your VM instances as needed.

To
[create-instance-group](https://github.com/JeffDeCola/my-packer-image-builds/blob/master/google-compute-engine-images/jeffs-gce-image-ubuntu-2204/create-instance-group.sh),

```bash
cd my-packer-image-builds/google-compute-engine-images/jeffs-gce-image-ubuntu-2204
sh create-instance-group.sh "jeffs-hello-go-deploy-gce-instance-template" "hello-go-deploy-gce"
```

Check that the instance group and VM instance were created,

```bash
gcloud compute instance-groups list
gcloud compute instances list
```

## CHECK SERVICES ARE RUNNING

To ssh into your gce VM, I placed my public keys in gce
metadata ssh keys, which automatically
places them in the authorized_keys files on my VM,

```bash
ssh -i ~/.ssh/google_compute_engine jeff@<IP>
```

Check the docker service is running,

```bash
docker ps
docker logs -f --tail 10 -f hello-go-deploy-gce
```

Check that your hello-go.service is running,

```bash
# Remember, it kicks off /root/bin/hello-go
systemctl list-unit-files | grep hello.go
sudo systemctl status hello-go
journalctl -f
sudo systemctl stop hello-go
cat /lib/systemd/system/hello-go.service
```

## CONTINUOUS INTEGRATION & DEPLOYMENT

Refer to
[ci-README.md](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/ci-README.md)
on how I automated the above steps using concourse.
