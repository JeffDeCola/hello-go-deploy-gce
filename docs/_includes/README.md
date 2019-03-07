
# REQUIREMENTS

You obviously need
[concourse](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/operations-tools/continuous-integration-continuous-deployment/concourse-cheat-sheet).

To build you will need,

* DockerHub account
* For manual testing,
  [docker](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/operations-tools/orchestration/builds-deployment-containers/docker-cheat-sheet)
  running on your machine.

To deploy you will need,

* [marathon](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/operations-tools/orchestration/cluster-managers-resource-management-scheduling/marathon-cheat-sheet-sheet)
* [mesos](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/operations-tools/orchestration/cluster-managers-resource-management-scheduling/mesos-cheat-sheet)

## LONG-RUNNING APP FOR MARATHON

Written in go, every 3 seconds `hello-go` will print:

```bash
Hello everyone, count is: 1
Hello everyone, count is: 2
Hello everyone, count is: 3
etc...
```

## RUN SOURCE CODE FROM THE COMMAND LINE

```bash
go run main.go
```

## BUILD - DOCKER IMAGE

Create a binary `hello-go`,

```bash
go build -o hello-go main.go
```

Grab the Dockerfile to put in this directory,

```bash
cp ci/Dockerfile .
```

Build your docker image using Dockerfile,

```bash
docker build -t jeffdecola/hello-go .
```

Obviously, replace `jeffdecola` with your DockerHub username.

Check your docker images,

```bash
docker images
```

It will be listed as `jeffdecola/hello-go`

## BUILD - PUSH DOCKER IMAGE TO DOCKER HUB

Push to your newly built docker image to DockerHub.

```bash
docker login
docker push jeffdecola/hello-go
```

Check you image at DockerHub. My image is
[https://hub.docker.com/r/jeffdecola/hello-go](https://hub.docker.com/r/jeffdecola/hello-go).

Once image is is on DockerHub, you can run in interactive mode (-i)
so you can `ctrl-c` to stop.

Erase your local image first to prove it grabs it from dockerhub,

```bash
docker rmi jeffdecola/hello-go
```

Now run it. Docker will grab the image from dockerHub
and start a docker container on your machine.

```bash
docker run -t -i jeffdecola/hello-go
```

## DEPLOY - APP TO MARATHON

The marathon .json file,

[_`resource-marathon-deploy`_](https://github.com/JeffDeCola/resource-marathon-deploy)
uses a Marathon .json file (app.json) to deploys the newly created docker image
(APP) to Marathon.

The `hello-go` docker image can now be manually deployed from
DockerHub to mesos/marathon by using the command:

```bash
curl -X PUT http://10.141.141.10:8080/v2/apps/hello-go-long-running -d @app.json \
-H "Content-type: application/json"
```

The `app.json` file will pick the latest image a DockerHub
`jeffdecola/hello-go:latest`.

## TESTED, BUILT & PUSHED TO DOCKERHUB USING CONCOURSE

To automate the creation of the `hello-go` docker image, a concourse pipeline
will,

* Update README.md for hello-go github webpage.
* Unit Test the code.
* Build the docker image `hello-go` and push to DockerHub.
* Deploy the DockerHub image to mesos/marathon.

![IMAGE - hello-go concourse ci pipeline - IMAGE](pics/hello-go-pipeline.jpg)

As seen in the pipeline diagram, the _resource-dump-to-dockerhub_ uses
the resource type
[docker-image](https://github.com/concourse/docker-image-resource)
to push a docker image to dockerhub.

[_`resource-marathon-deploy`_](https://github.com/JeffDeCola/resource-marathon-deploy)
deploys the newly created docker image to marathon.

`hello-go` also contains a few extra concourse resources:

* A resource (_resource-slack-alert_) uses a [docker image](https://hub.docker.com/r/cfcommunity/slack-notification-resource)
  that will notify slack on your progress.
* A resource (_resource-repo-status_) use a [docker image](https://hub.docker.com/r/dpb587/github-status-resource)
  that will update your git status for that particular commit.
* A resource ([_`resource-template`_](https://github.com/JeffDeCola/resource-template))
  that can be used as a starting point and template for creating other concourse
  ci resources.

For more information on using concourse for continuous integration,
refer to my cheat sheet on [concourse](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/operations-tools/continuous-integration-continuous-deployment/concourse-cheat-sheet).
