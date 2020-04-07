#!/usr/bin/bash

# BASIC SCRIPT CONF

defaultdir=$(xdg-user-dir DOWNLOAD)
imgs='\.jpg$|\.png$|\.jpeg$'

# COMMAND HELP INSTRUCTIONS

helpcall () {
echo \
"USAGE: mvdl [options] DEST 

Move the most recent file from users' default download folder to 
directory DEST.
DEST as a mandatory parameter must be a valid directory and have a valid file
which name matches the optional given match options.
Match options are:
 -i, --image		Filter for images only files.
 			Images files are considered those that matches the
			pattern *.jpeg, *.jpg or *.png.
 -h, --help		Call for command help documentation.";}

# PARSING COMMAND LINE ARGUMENTS

while ! [[ -v target ]] && [[ $# -gt 0 ]]; do
	case $1 in
		-h | --help)	# CALL HELP FUNCTION
		helpcall; exit 0;;

		-i|--image)	# OPTION -i FOR MATCHING ONLY IMAGE FILES
		dlfile=$(ls -t  $defaultdir | \
			egrep $imgs | sed -n '1p'); shift;;

		*)	# DEFAULT OPERATION
		! [[ -v dlfile ]] && \
			dlfile=$(ls -t $defaultdir | sed -n '1p')
		target=$1; shift;;
	esac;
done;

# CHECKING MATCHED FILE

! [[ -n $dlfile ]] && echo "failed: no matches in $defaultdir."  && exit 1

# CHECKING DEST DIRECTORY 

! [[ -v target ]] && echo "failed: missing target directory." && exit 1
! [[ -d $target ]] && echo "failed: target directory doesn't exist." && exit 1

# MOVING FILE TO DEST DIRECTORY

mv $defaultdir/$dlfile $target
echo "action: $dlfile moved to ${target/#./$(pwd)}."
exit 0
