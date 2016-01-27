#!/bin/bash

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

Flag=false
Valid () {
    if [[ "$(ls -A $PROJECTPATH)" ]]; then
        echo "A project for a language has already been initialized in the folder! Ignoring!"
        Flag=false
    else
        Flag=true
    fi    
}

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

Valid

for i in $@; do
	case $i in
		"-c") 
            Valid
            if [[ "$Flag" = true ]]; then
		        CTypeProject
            fi ;;
		"-cpp")
            Valid
            if [[ "$Flag" = true ]]; then
                CTypeProject
            fi ;;
		"-java")
            Valid
            if [[ "$Flag" = true ]]; then
                JavaProject
            fi ;;
		"-py")
            Valid
            if [[ "$Flag" = true ]]; then
                InterpretedProject
            fi ;;
		"-rb")
            Valid
            if [[ "$Flag" = true ]]; then
                InterpretedProject
            fi ;;
		"-rails")
            Valid
            if [[ "$Flag" = true ]]; then
                cd $PROJECTPATH && rails new . 
            fi ;;
		"-vcs") git init --quiet $PROJECTPATH ;;
		"-tags") cd $PROJECTPATH && ctags -R . ;;
	esac	
done
