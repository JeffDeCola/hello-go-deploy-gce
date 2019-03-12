
# PREREQUISITES

For this exercise I used go.  Feel free to use a language of your choice,

* [go](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/development/languages/go-cheat-sheet)

To build a docker image you will need docker on your machine,

* [docker](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/orchestration/builds-deployment-containers/docker-cheat-sheet)

To push a docker image you will need,

* [DockerHub account](https://hub.docker.com/)

To deploy to mesos/marathon you will need,

* [marathon](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/orchestration/cluster-managers-resource-management-scheduling/marathon-cheat-sheet)
* [mesos](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/orchestration/cluster-managers-resource-management-scheduling/mesos-cheat-sheet)

As a bonus, you can use Concourse CI to run the scripts,

* [concourse](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/continuous-integration-continuous-deployment/concourse-cheat-sheet)
  (Optional)

## RUN

To run from the command line,

```bash
go run main.go
```

Every 2 seconds `hello-go-deploy-gce` will print:

```bash
Hello everyone, count is: 1
Hello everyone, count is: 2
Hello everyone, count is: 3
etc...
```

## STEP 1 - TEST

Lets unit test the code,

```bash
go test -cover ./... | tee /test/test_coverage.txt
```

This script runs the above command
[/test/unit-tests.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/test/unit-tests.sh).

This script runs the above command in concourse
[/ci/scripts/unit-test.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/ci/scripts/unit-tests.sh).

## STEP 2 - BUILD (DOCKER IMAGE)

Lets build a docker image from your binary `/bin/hello-go`.

First, create a binary `hello-go`,
I keep my binaries in `/bin`.

```bash
go build -o bin/hello-go main.go
```

Copy the binary to `/build-push` because docker needs it in
same directory as Dockerfile,

```bash
cp bin/hello-go build-push/.
cd build-push
```

Build your docker image from binary `hello-go`
using `Dockerfile`,

```bash
docker build -t jeffdecola/hello-go-deploy-gce .
```

Obviously, replace `jeffdecola` with your DockerHub username.

Check your docker images on your machine,

```bash
docker images
```

It will be listed as `jeffdecola/hello-go-deploy-gce`

You can test your dockerhub image,

```bash
docker run jeffdecola/hello-go-deploy-gce
```

This script runs the above commands
[/build-push/build-push.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/build-push/build-push.sh).

This script runs the above commands in concourse
[/ci/scripts/build-push.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/ci/scripts/build-push.sh).

## STEP 3 - PUSH (TO DOCKERHUB)

Lets push your docker image to DockerHub.

If you are not logged in, you need to login to dockerhub,

```bash
docker login
```

Once logged in you can push,

```bash
docker push jeffdecola/hello-go-deploy-gce
```

Check you image at DockerHub. My image is located
[https://hub.docker.com/r/jeffdecola/hello-go-deploy-gce](https://hub.docker.com/r/jeffdecola/hello-go-deploy-gce).

This script runs the above commands
[/build-push/build-push.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/build-push/build-push.sh).

This script runs the above commands in concourse
[/ci/scripts/build-push.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/ci/scripts/build-push.sh).

## STEP 4 - DEPLOY (TO MARATHON)

Lets pull the `hello-go-deploy-gce` docker image
from DockerHub and deploy to mesos/marathon.

This is actually very simple, you just PUT the
[/deploy/app.json](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/deploy/app.json)
file to mesos/marathon. This json file tells marathon what to do.

```bash
curl -X PUT http://10.141.141.10:8080/v2/apps/hello-go-long-running \
-d @app.json \
-H "Content-type: application/json"
```

This script runs the above commands
[/deploy/deploy.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/deploy/deploy.sh).

This script runs the above commands in concourse
[/ci/scripts/deploy.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/ci/scripts/deploy.sh).

## TEST, BUILT, PUSH & DEPLOY USING CONCOURSE (OPTIONAL)

For fun, I use concourse to automate the above steps.

A pipeline file [pipeline.yml](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/ci/pipeline.yml)
shows the entire ci flow. Visually, it looks like,

![IMAGE - hello-go-deploy-gce concourse ci pipeline - IMAGE](pics/hello-go-deploy-gce-pipeline.jpg)

The `jobs` and `tasks` are,

* `job-readme-github-pages` runs task
  [readme-github-pages.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/ci/scripts/readme-github-pages.sh).
* `job-unit-tests` runs task
  [unit-tests.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/ci/scripts/unit-tests.sh).
* `job-build-push` runs task
  [build-push.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/ci/scripts/build-push.sh).
* `job-deploy` runs task
  [deploy.sh](https://github.com/JeffDeCola/hello-go-deploy-gce/tree/master/ci/scripts/deploy.sh).

The concourse `resources type` are,

* `hello-go-deploy-gce` uses a resource type
  [docker-image](https://hub.docker.com/r/concourse/git-resource/)
  to PULL a repo from github.
* `resource-dump-to-dockerhub` uses a resource type
  [docker-image](https://hub.docker.com/r/concourse/docker-image-resource/)
  to PUSH a docker image to dockerhub.
* `resource-marathon` users a resource type
  [docker-image](https://hub.docker.com/r/ckaznocha/marathon-resource)
  to DEPLOY the newly created docker image to marathon.
* `resource-slack-alert` uses a resource type
  [docker image](https://hub.docker.com/r/cfcommunity/slack-notification-resource)
  that will notify slack on your progress.
* `resource-repo-status` uses a resource type
  [docker image](https://hub.docker.com/r/dpb587/github-status-resource)
  that will update your git status for that particular commit.

For more information on using concourse for continuous integration,
refer to my cheat sheet on [concourse](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/continuous-integration-continuous-deployment/concourse-cheat-sheet).
