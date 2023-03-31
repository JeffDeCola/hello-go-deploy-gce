#!/bin/sh
# hello-go-deploy-aws readme-github-pages.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "readme-github-pages.sh -debug (START)"
    echo " "
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -x
    echo " "
else
    echo " "
    echo "readme-github-pages.sh (START)"
    echo " "
fi

echo "cd up to /hello-go-deploy-aws directory"
echo " "
cd ..

echo "FOR GITHUB WEBPAGES"
echo "THE GOAL IS TO COPY README.md to /docs/_includes/README.md"
echo " "

echo "Remove everything before the second heading in README.md.  Place in temp-README.md"
sed '0,/GitHub Webpage/d' README.md > temp-README.md
# Change the first heading ## to #
sed -i '0,/##/{s/##/#/}' temp-README.md
# update the image links (remove docs/)
sed -i 's#IMAGE](docs/#IMAGE](#g' temp-README.md
echo " "

isDiff="yes"

echo "Does docs/_includes/README.md exist?"
if test -f docs/_includes/README.md
then
    echo "    Yes, it exists."
    # CHECK IF THERE IS A DIFF
    if (cmp -s temp-README.md docs/_includes/README.md)
    then
        isDiff="no"
        echo "    No Changes are needed."
    else
        echo "    Updates are needed."
    fi
    echo " "
else
    echo "    No, it does not exist."
    echo "    Creating the _includes directory"
    mkdir docs/_includes
    echo " "
fi

if [ "$isDiff" = "yes" ]
then
    echo "cp updated temp-README.md to docs/_includes/README.md"
    cp temp-README.md docs/_includes/README.md
    echo " "
fi

echo "remove temp-README.md"
rm temp-README.md
echo " "

echo "readme-github-pages.sh (END)"
echo " "
