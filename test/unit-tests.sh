#!/bin/sh
# hello-go-deploy-gce unit-test.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "unit-tests.sh -debug (START)"
    echo " "
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -x
    echo " "
else
    echo " "
    echo "unit-tests.sh (START)"
    echo " "
fi

echo "cd up to /hello-go-deploy-gce directory"
cd ..
echo " "

echo "Run go test -cover"
echo "   -cover shows the percentage coverage"
echo "   Put results in /test/test_coverage.txt file"
go test -cover ./... | tee test/test_coverage.txt
echo " "

echo "unit-tests.sh (END)"
echo " "
