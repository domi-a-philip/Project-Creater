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
        PROJECTPATH="$PWD/$PROJECTNAME"
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

WebProject () {
    mkdir "$PROJECTPATH/src"
    mkdir "$PROJECTPATH/assets"
    mkdir -p "$PROJECTPATH/assets/fonts"
    mkdir -p "$PROJECTPATH/assets/images"
    mkdir -p "$PROJECTPATH/assets/sounds"
    mkdir "$PROJECTPATH/style"
    cd "$PROJECTPATH" && touch "index.html"
}

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
        "-js")
            Valid
            if [[ "$Flag" = true ]]; then
                WebProject
            fi ;;
        "-sails")
            Valid
            if [[ "$Flag" = true ]]; then
                cd $PROJECTPATH && sails new .
            fi ;;
		"-rails")
            Valid
            if [[ "$Flag" = true ]]; then
                cd $PROJECTPATH && rails new . 
            fi ;;
		"-vcs") 
            git init --quiet $PROJECTPATH ;;
		"-tags") 
            cd $PROJECTPATH && ctags -R . ;;
        *)
            echo "Error '$i' is not a valid argument." ;;
	esac    
done

isVCS=0
isTAGS=0

for i in $@; do
    case $i in
        "-vcs")
            isVCS=1 ;;
        "-tags")
            isTAGS=1 ;;
    esac
done

if [ $isVCS -eq 1 ] && [ $isTAGS -eq 1 ]; then
    echo "tags" >> $PROJECTPATH/.git/info/exclude

    echo "#!/bin/sh" >> $PROJECTPATH/.git/hooks/post-checkout
    echo -en '\n' >> $PROJECTPATH/.git/hooks/post-checkout
    echo "ctags -R ." >> $PROJECTPATH/.git/hooks/post-checkout
    chmod +x $PROJECTPATH/.git/hooks/post-checkout

    echo "#!/bin/sh" >> $PROJECTPATH/.git/hooks/post-merge
    echo -en '\n' >> $PROJECTPATH/.git/hooks/post-merge
    echo "ctags -R ." >> $PROJECTPATH/.git/hooks/post-merge
    chmod +x $PROJECTPATH/.git/hooks/post-merge

    echo "#!/bin/sh" >> $PROJECTPATH/.git/hooks/post-receive
    echo -en '\n' >> $PROJECTPATH/.git/hooks/post-receive
    echo "ctags -R ." >> $PROJECTPATH/.git/hooks/post-receive
    chmod +x $PROJECTPATH/.git/hooks/post-receive

    echo "#!/bin/sh" >> $PROJECTPATH/.git/hooks/post-update
    echo -en '\n' >> $PROJECTPATH/.git/hooks/post-update
    echo "ctags -R ." >> $PROJECTPATH/.git/hooks/post-update
    chmod +x $PROJECTPATH/.git/hooks/post-update

    echo "#!/bin/sh" >> $PROJECTPATH/.git/hooks/pre-commit
    echo -en '\n' >> $PROJECTPATH/.git/hooks/pre-commit
    echo "ctags -R ." >> $PROJECTPATH/.git/hooks/pre-commit
    chmod +x $PROJECTPATH/.git/hooks/pre-commit

    echo "#!/bin/sh" >> $PROJECTPATH/.git/hooks/pre-push
    echo -en '\n' >> $PROJECTPATH/.git/hooks/pre-push
    echo "ctags -R ." >> $PROJECTPATH/.git/hooks/pre-push
    chmod +x $PROJECTPATH/.git/hooks/pre-push

    echo "#!/bin/sh" >> $PROJECTPATH/.git/hooks/update
    echo -en '\n' >> $PROJECTPATH/.git/hooks/update
    echo "ctags -R ." >> $PROJECTPATH/.git/hooks/update
    chmod +x $PROJECTPATH/.git/hooks/update
fi
