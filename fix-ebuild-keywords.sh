# *****************************************************************************************
# find_and_replace_in_files.sh
# This script does a recursive, case sensitive directory search and replace of files
# To make a case insensitive search replace, use the -i switch in the grep call
# uses a startdirectory parameter so that you can run it outside of specified directory - else this script will modify itself!
# *****************************************************************************************

!/bin/bash
# **************** Change Variables Here ************
startdirectory="./"
searchterm="KEYWORDS="~amd64""
replaceterm="KEYWORDS="~x86 ~amd64 ~arm ~arm64 ""
# **********************************************************

echo "***************************************************"
echo "* Search and Replace in Files Version 01-Aug-2012 *"
echo "***************************************************"

i=0; 

  for file in $(grep -l -R $searchterm $startdirectory)
    do
      cp $file $file.bak
      sed -e "s/$searchterm/$replaceterm/ig" $file > tempfile.tmp
      mv tempfile.tmp $file

    let i++;

      echo "Modified: " $file
    done

echo " *** All Done! *** Modified files:" $i
