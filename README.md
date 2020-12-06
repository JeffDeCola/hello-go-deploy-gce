# hello-go-deploy-gce

[![Go Report Card](https://goreportcard.com/badge/github.com/JeffDeCola/hello-go-deploy-gce)](https://goreportcard.com/report/github.com/JeffDeCola/hello-go-deploy-gce)
[![GoDoc](https://godoc.org/github.com/JeffDeCola/hello-go-deploy-gce?status.svg)](https://godoc.org/github.com/JeffDeCola/hello-go-deploy-gce)
[![Maintainability](https://api.codeclimate.com/v1/badges/1dff96727b972dd4cda4/maintainability)](https://codeclimate.com/github/JeffDeCola/hello-go-deploy-gce/maintainability)
[![Issue Count](https://codeclimate.com/github/JeffDeCola/hello-go-deploy-gce/badges/issue_count.svg)](https://codeclimate.com/github/JeffDeCola/hello-go-deploy-gce/issues)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://jeffdecola.mit-license.org)

`hello-go-deploy-gce` _will test, build, push (to DockerHub) and deploy
a long running "hello-world" Docker Image to Google Compute Engine (gce).
Also, it will enable a hello-go.service that kicks off the binary hello-go at boot._

I also have other repos showing different deployments,

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

Table of Contents,

* [OVERVIEW](https://github.com/JeffDeCola/hello-go-deploy-gce#overview)
* [PREREQUISITES](https://github.com/JeffDeCola/hello-go-deploy-gce#prerequisites)
* [RUN](https://github.com/JeffDeCola/hello-go-deploy-gce#run)
* [CREATE BINARY](https://github.com/JeffDeCola/hello-go-deploy-gce#create-binary)
* [STEP 1 - TEST](https://github.com/JeffDeCola/hello-go-deploy-gce#step-1---test)
* [STEP 2 - BUILD (DOCKER IMAGE VIA DOCKERFILE)](https://github.com/JeffDeCola/hello-go-deploy-gce#step-2---build-docker-image-via-dockerfile)
* [STEP 3 - PUSH (TO DOCKERHUB)](https://github.com/JeffDeCola/hello-go-deploy-gce#step-3---push-to-dockerhub)
* [STEP 4 - DEPLOY (TO GCE)](https://github.com/JeffDeCola/hello-go-deploy-gce#step-4---deploy-to-gce)
  * [STEP 4.1 CREATE A CUSTOM MACHINE IMAGE (USING PACKER)](https://github.com/JeffDeCola/hello-go-deploy-gce#step-41-create-a-custom-machine-image-using-packer)
  * [STEP 4.2 CREATE AN INSTANCE TEMPLATE](https://github.com/JeffDeCola/hello-go-deploy-gce#step-42-create-an-instance-template)
  * [STEP 4.3 CREATE AN INSTANCE GROUP](https://github.com/JeffDeCola/hello-go-deploy-gce#step-43-create-an-instance-group)
  * [STEP 4.4 AUTOSCALING (OPTIONAL)](https://github.com/JeffDeCola/hello-go-deploy-gce#step-44-autoscaling-optional)
* [CONTINUOUS INTEGRATION & DEPLOYMENT](https://github.com/JeffDeCola/hello-go-deploy-gce#continuous-integration--deployment)
* [CHECK THAT hello-go IS RUNNING ON YOUR VM INSTANCE](https://github.com/JeffDeCola/hello-go-deploy-gce#check-that-hello-go-is-running-on-your-vm-instance)
* [A HIGH-LEVEL VIEW OF GCE](https://github.com/JeffDeCola/hello-go-deploy-gce#a-high-level-view-of-gce)

Documentation and references,

* The
  [hello-go-deploy-gce](https://hub.docker.com/r/jeffdecola/hello-go-deploy-gce)
  docker image on DockerHub

[GitHub Webpage](https://jeffdecola.github.io/hello-go-deploy-gce/)
_built with
[concourse ci](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/ci-README.md)_

## OVERVIEW

Every 2 seconds it will print,

```txt
    INFO[0000] Let's Start this!
    Hello everyone, count is: 1
    Hello everyone, count is: 2
    Hello everyone, count is: 3
    etc...
```

## PREREQUISITES

I used the following language,

* [go](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/development/languages/go-cheat-sheet)

You will need the following go packages,

```bash
go get -u -v github.com/sirupsen/logrus
```

To build a docker image you will need docker on your machine,

* [docker](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/orchestration/builds-deployment-containers/docker-cheat-sheet)

To push a docker image you will need,

* [DockerHub account](https://hub.docker.com/)

To deploy to `gce` you will need,

* [google compute engine (gce)](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/service-architectures/infrastructure-as-a-service/google-compute-engine-cheat-sheet)
* [packer](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/orchestration/builds-deployment-containers/packer-cheat-sheet)

As a bonus, you can use Concourse CI,

* [concourse](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/continuous-integration-continuous-deployment/concourse-cheat-sheet)

## RUN

The following steps are located in
[run.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/run.sh).

To run
[main.go](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/main.go)
from the command line,

```bash
cd example-01
go run main.go
```

## CREATE BINARY

The following steps are located in
[create-binary.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/bin/create-binary.sh).

```bash
cd example-01
go build -o bin/hello-go main.go
cd bin
./hello-go
```

This binary will not be used during a docker build
since it creates it's own.

## STEP 1 - TEST

The following steps are located in
[unit-tests.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/example-01/test/unit-tests.sh).

To unit test the code,

```bash
cd example-01
go test -cover ./... | tee test/test_coverage.txt
cat test/test_coverage.txt
```

To create `_test` files,

```bash
gotests -w -all main.go
```

## STEP 2 - BUILD (DOCKER IMAGE VIA DOCKERFILE)

The following steps are located in
[build.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/build-push/build.sh).

We will be using a multi-stage build using a
[Dockerfile](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/build-push/Dockerfile).
The end result will be a very small docker image around 13MB.

```bash
cd example-01
docker build -f build-push/Dockerfile -t jeffdecola/hello-go-deploy-gce .
```

You can check and test this docker image,

```bash
docker images jeffdecola/hello-go-deploy-gce:latest
docker run --name hello-go-deploy-gce -dit jeffdecola/hello-go-deploy-gce
docker exec -i -t hello-go-deploy-gce /bin/bash
docker logs hello-go-deploy-gce
```

### Stage 1

In stage 1, rather than copy a binary into a docker image (because
that can cause issue), **the Dockerfile will build the binary in the
docker image.**

If you open the DockerFile you can see it will get the dependencies and
build the binary in go,

```bash
FROM golang:alpine AS builder
RUN go get -d -v
RUN go build -o /go/bin/hello-go-deploy-gce main.go
```

### Stage 2

In stage 2, the Dockerfile will copy the binary created in
stage 1 and place into a smaller docker base image based
on `alpine`, which is around 13MB.

## STEP 3 - PUSH (TO DOCKERHUB)

The following steps are located in
[push.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/build-push/push.sh).

If you are not logged in, you need to login to dockerhub,

```bash
docker login
```

Once logged in you can push to DockerHub,

```bash
docker push jeffdecola/hello-go-deploy-gce
```

Check the
[hello-go-deploy-gce](https://hub.docker.com/r/jeffdecola/hello-go-deploy-gce)
docker image at DockerHub.

## STEP 4 - DEPLOY (TO GCE)

Refer to my
[gce cheat sheet](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/service-architectures/infrastructure-as-a-service/google-compute-engine-cheat-sheet)
for more detailed information and some nice illustrations.

There are three steps to deployment on `gce`,

* STEP 4.1 - Build a custom `image` using `packer` -
  Your boot disk that contains all your stuff (the `hello-go-deploy-gce` docker image).
* STEP 4.2 - Create an `instance template` - What HW resources you want for your
  VM instance.
* STEP 4.3 - Create an `instance group` - Will deploy and scale you VM instance(s).

The end goal is to have the following two services
running at boot on the VM,

* The dockerhub image `hello-go-deploy-gce`.
* The binary /bin/hello-go.

### STEP 4.1 CREATE A CUSTOM MACHINE IMAGE (USING PACKER)

Packer will be used to create the gce custom machine `image` from the
[packer template file](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/example-01/deploy-gce/build-image/gce-packer-template.json).

Run this command,

```bash
packer $command \
    -var "account_file=$GCP_JEFFS_APP_SERVICE_ACCOUNT_PATH" \
    -var "project_id=$GCP_JEFFS_PROJECT_ID" \
    gce-packer-template.json
```

Inside the packer template file the following configurations and provisions
were done on the soon to be custom machine image,

To be able to clone a repo, you will need to create public/private
(`gce-github-vm` & `gce-github-vm.pub`) ssh keys and put the public
key at github. Place these keys in your `~/.ssh` folder.

Also note, this image will enable both the docker container and
a service at boot.

* [add-user-jeff.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/add-user-jeff.sh)
  Add jeff as a user.
* [add-gce-universal-key-to-jeff.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/add-gce-universal-key-to-jeff.sh)
  Add a universal key to jeff so VMs can ssh into each other using host.
* [move-welcome-file.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/move-welcome-file.sh)
  Add a welcome file in /home/jeff for fun.
* [setup-github-ssh-keys.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/setup-github-ssh-keys.sh)
  Connect to github.
* [upgrade-system.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/upgrade-system.sh)
  update and upgrade.
* [install-packages.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/install-packages.sh)
  apt-get stuff.
* [install-docker.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/install-docker.sh)
  Install docker.
* [install-go.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/install-go.sh)
  Install go 1.10.3.
* [pull-private-repos.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/pull-private-repos.sh)
  Get this repo, place in /root/src.
* [install-service.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/install-service.sh)
  Build the service.
* [enable-service-boot.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/enable-service-boot.sh)
  enable at boot.
* [enable-docker-container-boot.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/enable-docker-container-boot.sh)
  Enable docker container at boot.
* [remove-github-ssh-keys.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/example-01/deploy-gce/build-image/install-scripts/remove-github-ssh-keys.sh)
  For security, remove the github keys.

Check on `gce` that the image was created,

```bash
gcloud compute images list --no-standard-images
```

Refer to my
[create a custom image using packer](https://github.com/JeffDeCola/my-cheat-sheets/blob/master/software/service-architectures/infrastructure-as-a-service/google-compute-engine-cheat-sheet/google-compute-engine-create-image-packer.md)
cheat sheet for more detailed information on how to do this.

This script runs the create a custom `image` (using packer) commands.
[/deploy-gce/build-image/build-image.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/example-01/deploy-gce/build-image/build-image.sh).

### STEP 4.2 CREATE AN INSTANCE TEMPLATE

The `instance template` contains the HW resources the `instance group`
needs to create the VM instance.

Run the following to create the instance template,

```bash
IMAGENAME="$1"
PREFIX="jeff"
SERVICE="hello-go"
POSTFIX="date -u +%Y%m%d"

gcloud compute \
    --project "$GCP_JEFFS_PROJECT_ID" \
     instance-templates create "$PREFIX-$SERVICE-instance-template-$POSTFIX" \
    --machine-type "f1-micro" \
    --network "default" \
    --maintenance-policy "TERMINATE" \
    --tags "jeff-test" \
    --image "$IMAGENAME" \
    --boot-disk-size "10" \
    --boot-disk-type "pd-standard" \
    --boot-disk-device-name "$PREFIX-$SERVICE-disk-$POSTFIX" \
    --description "hello-go from Jeffs Repo hello-go-deploy-gce" \
    --region "us-west1"
    # --service-account=SERVICE_ACCOUNT
    # --preemptible \
```

Check on `gce` that the instance template was created,

```bash
gcloud compute instance-templates list
```

This script runs the create an `instance template` commands.
[/deploy-gce/create-instance-template/create-instance-template.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/example-01/deploy-gce/create-instance-template/create-instance-template.sh).

Online docs [here](https://cloud.google.com/sdk/gcloud/reference/compute/instance-templates/create)
to create instance template.

### STEP 4.3 CREATE AN INSTANCE GROUP

The instance group controls the show. It launches your VM instance
and scales your VM instances as needed.

```bash
TEMPLATENAME="$1"
PREFIX="jeff"
SERVICE="hello-go"
POSTFIX="date -u +%Y%m%d"

gcloud compute \
    --project "$GCP_JEFFS_PROJECT_ID" \
    instance-groups managed create "$PREFIX-$SERVICE-instance-group-$POSTFIX" \
    --size "1" \
    --template "$TEMPLATENAME" \
    --base-instance-name "$PREFIX-$SERVICE-instance-$POSTFIX" \
    --zone "us-west1-a" \
    --description "hello-go from Jeffs Repo hello-go-deploy-gce"
```

Check on `gce` that the `instance group` and VM `instance` was created,

```bash
gcloud compute instance-groups list
gcloud compute instances list
```

This script runs the create an `instance group` commands.
[/deploy-gce/create-instance-group/create-instance-group.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/example-01/deploy-gce/create-instance-group/create-instance-group.sh).

Lastly, this script runs all of the above commands in concourse
[/ci/scripts/deploy.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/ci/scripts/deploy.sh).

Online docs to create [managed](https://cloud.google.com/sdk/gcloud/reference/compute/instance-groups/managed/create)
or [unmanaged](https://cloud.google.com/sdk/gcloud/reference/compute/instance-groups/unmanaged/create)
instance group.

### STEP 4.4 AUTOSCALING (OPTIONAL)

I'll eventually do this at a later date.

```bash
gcloud compute instance-groups managed set-autoscaling
```

This script configures the autoscalling for `the instance groups`
[/deploy-gce/create-instance-group/autoscaling.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/example-01/deploy-gce/create-instance-group/autoscaling.sh).

Online docs to create [managed](https://cloud.google.com/sdk/gcloud/reference/compute/instance-groups/managed/create)
or [unmanaged](https://cloud.google.com/sdk/gcloud/reference/compute/instance-groups/unmanaged/create)
instance group.

## CONTINUOUS INTEGRATION & DEPLOYMENT

Refer to
[ci-README.md](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/ci-README.md)
on how I automated the above steps.

## CHECK THAT hello-go IS RUNNING ON YOUR VM INSTANCE

`ssh` into your VM instance.  This is easy from the gce console.

I actually ssh from my machine since I placed my public keys in gce metadata
sshkeys, which automatically placed them in the authorized_keys files on my VM.
Refer
[here](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/service-architectures/infrastructure-as-a-service/google-compute-engine-cheat-sheet#instances---gce-metadata---startup-scripts)
on how to do that,

```bash
ssh -i ~/.ssh/google_compute_engine jeff@IP
```

Check the logs (stdout) of the running docker container and shell script.
Remember, you must be root.

Check docker is running,

```bash
docker ps
docker logs -f --tail 10 -f hello-go
docker stop hello-go
```

Check that your hello-go.service is running,

```bash
systemctl list-unit-files | grep hello.go
sudo systemctl status hello-go
journalctl -f
sudo systemctl stop hello-go
cat /lib/systemd/system/hello-go.service
# Remember, it kicks off /root/bin/hello-go
```

Lastly, if you have multiple VMS, and since you put the
same ssh keys in `/home/jeff/.ssh` when you built the image with packer,
your VMs can talk to each other using gce's internal DNS.

```bash
ssh <USERNAME>@<HOSTNAME>.us-west1-a.c.<PROJECT>.internal
```

That's it, you did a lot, have a beer and I hope you had fun.

## A HIGH-LEVEL VIEW OF GCE

Here is an illustration showing how everything fits together,

![IMAGE -  google compute engine creating deploying custom image - IMAGE](https://github.com/JeffDeCola/my-cheat-sheets/blob/master/docs/pics/gce-overview-creating-deploying-custom-image.jpg)
