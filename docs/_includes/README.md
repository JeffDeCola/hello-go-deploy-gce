  _built with
  [concourse](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/ci-README.md)_

# OVERVIEW

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

* STEP 4.1 - Build a gce image (insert your docker image)
* STEP 4.2 - Create an instance template (HW resources)
* STEP 4.3 - Create an instance group (Launch VM in region)

For this example, I will add two running services,

* The dockerhub image
  [hello-go-deploy-gce](https://hub.docker.com/r/jeffdecola/hello-go-deploy-gce/)
* A binary /bin/hello-go executable

To keep things simple, the files are located in my
[my-packer-image-builds](https://github.com/JeffDeCola/my-packer-image-builds)
repo.

### STEP 4.1 BUILD A CUSTOM MACHINE IMAGE USING PACKER

To validate your packer file,

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

### STEP 4.3 CREATE AN INSTANCE GROUP

### CHECK THAT HELLO-GO IS RUNNING ON YOUR VM INSTANCE

### A HIGH-LEVEL VIEW OF GCE

## CONTINUOUS INTEGRATION & DEPLOYMENT

Refer to
[ci-README.md](https://github.com/JeffDeCola/hello-go-deploy-gce/blob/master/ci-README.md)
on how I automated the above steps using concourse.
