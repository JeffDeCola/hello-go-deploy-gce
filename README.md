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
Google Compute Engine (gce).

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
* [CONTINUOUS INTEGRATION & DEPLOYMENT](https://github.com/JeffDeCola/hello-go-deploy-gce#continuous-integration--deployment)

Documentation and Reference

* The
  [hello-go-deploy-gce docker image](https://hub.docker.com/r/jeffdecola/hello-go-deploy-gce)
  on DockerHub
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

## SOFTWARE STACK

* DEVELOPMENT
  * [go](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/development/languages/go-cheat-sheet)
* OPERATIONS
  * [concourse/fly](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations/continuous-integration-continuous-deployment/concourse-cheat-sheet)
    (optional)
  * [docker](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations/orchestration/builds-deployment-containers/docker-cheat-sheet)
* SERVICES
  * [dockerhub](https://hub.docker.com/)
  * google compute engine (gce)

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

_Coming soon._

## CONTINUOUS INTEGRATION & DEPLOYMENT

Refer to
[ci-README.md](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/ci-README.md)
on how I automated the above steps using concourse.
