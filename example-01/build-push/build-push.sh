#!/bin/sh -e
# hello-go-deploy-gce build-push.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "************************************************************************"
    echo "* build-push.sh -debug (START) *****************************************"
    echo "************************************************************************"
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -x
    echo " "
else
    echo "************************************************************************"
    echo "* build-push.sh (START) ************************************************"
    echo "************************************************************************"
    echo " "
fi

echo "cd up to code"
cd ..
echo " "

#echo "Create a binary hello-go in /bin"
#go build -o bin/hello-go main.go
#echo " "

#echo "Copy the binary in /build-push because docker needs it with Dockerfile"
#cp bin/hello-go build-push/.
#echo " "

#echo "cd build-push"
#cd build-push
#echo " "

echo "Build your docker image from binary /bin/hello-go using /build-push/Dockerfile"
docker build -f build-push/Dockerfile -t jeffdecola/hello-go-deploy-gce .
echo " "

echo "Image size"
docker images jeffdecola/hello-go-deploy-gce:latest
echo " "

echo "Assuming you are logged in, lets push your built docker image to DockerHub"
docker push jeffdecola/hello-go-deploy-gce
echo " "

echo "Useful commands:"
echo "     docker run --name hello-go-deploy-gce -dit jeffdecola/hello-go-deploy-gce"
echo "     docker exec -i -t hello-go-deploy-gce /bin/bash"
echo "     docker logs hello-go-deploy-gce"
echo " "

echo "************************************************************************"
echo "* build-push.sh (END) **************************************************"
echo "************************************************************************"
echo " "
