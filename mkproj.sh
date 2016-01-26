#!/bin/sh

if [ $# -eq 0 ]
  then
    echo "No arguments supplied!"
    exit
fi

echo "Please type the name of your project, followed by [Enter]."
read PROJECTNAME

PROJECTPATH="$PWD/$PROJECTNAME"

if [ -d $PROJECTPATH ]; then
	echo "Directory already exists! Please type the name a new project, followed by [Enter]."
	while [[ -d $PROJECTPATH ]]; do
		echo "Please type the name of your project, followed by [Enter]."
		read PROJECTNAME
	done
fi

mkdir $PROJECTPATH

CTypeProject ()	{
	mkdir "$PROJECTPATH/src"
	mkdir "$PROJECTPATH/bin"
	mkdir "$PROJECTPATH/docs"
	mkdir "$PROJECTPATH/ext"
	mkdir -p "$PROJECTPATH/ext/include"
	mkdir -p "$PROJECTPATH/ext/lib"
}

JavaProject () {
	mkdir "$PROJECTPATH/src"
	mkdir "$PROJECTPATH/bin"
	mkdir "$PROJECTPATH/docs"
}

InterpretedProject () {
	mkdir "$PROJECTPATH/src"
	mkdir "$PROJECTPATH/docs"
}

for i in $@; do
	case $i in
		"-c") CTypeProject ;;
		"-cpp") CTypeProject ;;
		"-java") JavaProject ;;
		"-py") InterpretedProject ;;
		"-rb") InterpretedProject ;;
		"-rails") cd $PROJECTPATH && rails new . ;;
		"-vcs") git init --quiet $PROJECTPATH ;;
		"-tags") cd $PROJECTPATH && ctags -R . ;;
	esac	
done