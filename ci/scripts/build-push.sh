#!/bin/sh
# hello-go-deploy-gce build-push.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "build-push.sh -debug (START)"
    # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status. Needed for concourse.
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -e -x
    echo " "
else
    echo "build-push.sh (START)"
    # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status.  Needed for concourse.
    set -e
    echo " "
fi

echo "The goal is to create a binary and place in /dist directory with a Dockerfile"
echo "The concourse pipeline will build and push the docker image to DockerHub"
echo " "
echo "At start, you should be in a /tmp/build/xxxxx directory with two folders:"
echo "   /hello-go-deploy-gce"
echo "   /dist (created in task-build-push.yml task file)"
echo " "

echo "pwd is: $PWD"
echo " "

echo "List whats in the current directory"
ls -la
echo " "

echo "Setup the GOPATH based on current directory"
export GOPATH=$PWD
echo " "

echo "Now we must move our code from the current directory ./hello-go-deploy-gce to" 
echo "$GOPATH/src/github.com/JeffDeCola/hello-go-deploy-gce"
mkdir -p src/github.com/JeffDeCola/
cp -R ./hello-go-deploy-gce src/github.com/JeffDeCola/.
echo " "

echo "cd src/github.com/JeffDeCola/hello-go-deploy-gce/example-01-gce"
cd src/github.com/JeffDeCola/hello-go-deploy-gce/example-01-gce
echo " "

echo "Check that you are set and everything is in the right place for go:"
echo "gopath is: $GOPATH"
echo "pwd is: $PWD"
ls -la

echo "Create a binary hello-go in /bin"
go build -o bin/hello-go main.go
echo ""

echo "cd to the /dist directory"
cd "$GOPATH/dist"
echo " "

echo "cp the binary into /dist"
cp "$GOPATH/src/github.com/JeffDeCola/hello-go-deploy-gce/example-01-gce/bin/hello-go" .
echo " "

echo "cp the Dockerfile into /dist"
cp "$GOPATH/src/github.com/JeffDeCola/hello-go-deploy-gce/example-01-gce/build-push/Dockerfile" .
echo " "

echo "Make it executable by all - chmod +x"
chmod +x hello-go
echo " "

echo "List whats in the /dist directory"
ls -la
echo " "

echo "The concourse pipeline will build and push the docker image to DockerHub"
echo " "

echo "build-push.sh (END)"
echo " "
