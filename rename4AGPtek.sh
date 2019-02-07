#!/bin/bash

# Copyright 2019 Jonathan Thomson
# Permission is hereby granted, free of charge, to any person obtaining a copy of 
# this software and associated documentation files (the "Software"), to deal in the 
# Software without restriction, including without limitation the rights to use, 
# copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
# Software, and to permit persons to whom the Software is furnished to do so, 
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN 
# AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# rename4AGPtek.sh
# Adds a sequential prefix to every mp3 file on the AGPtek or Ruizu player so that 
# it plays them in the correct order.
#
# If you run this script on the files on your player, then add a new file to your 
# player and run the script again it will delete all of the prefixs, and add on new 
# prefixes to all the files so that your new file will put in the right place 
# alphabetically.
#
# MP3_DIR is the directory of your player. It's better to use this script to rename 
# the files after they've been copied to the player.
#
# The ZERO_PADDING variable depends on the number of files and must be set correctly 
# for files to play in the right order.
# e.g. if you have 10s of files ZERO_PADDING should be set to 2, 100s of files 
# ZERO_PADDING should be 3, 1000s of files it should be 4, etc.
#
# If the number of files on your player increases from, for example 99 to 100, you 
# will need to set REMOVE_PREFIX_ONLY to true, run the script, increase ZERO_PADDING 
# from 2 to 3 and set REMOVE_PREFIX_ONLY to false, and then run the script again to 
# get the correctly zero padded prefixes.
#

shopt -s nullglob
IFS=$'\n'
MP3_DIR="/media/jthomson/9016-4EF8"
ZERO_PADDING=4 # zero padding, e.g. 4 --> 0001)
REMOVE_PREFIX_ONLY=false

i=1

dirlist=$(export LC_ALL=C; find $MP3_DIR -type d -print | sort)

for dir in $dirlist
do
  cd $dir
  echo $dir

  # strip the prefix off and sort so when update the prefixes so the prefixes are sequential with the filenames in alphabetical order
  sorted_base_filenames=$(find -mindepth 1 -maxdepth 1 -type f -name "*.mp3" -print | sed -r 's/^\.\///' | sed -r "s/[0-9]{$ZERO_PADDING}\) //" | sort)

  for f in $sorted_base_filenames; do
    current_filename=$(find -mindepth 1 -maxdepth 1 -type f -name "*$f" | sed -r 's/^\.\///')
    base_filename=$(echo $current_filename | sed -r "s/[0-9]{$ZERO_PADDING}\) //") #stripped of the number prefix if it has one
    if [ "$REMOVE_PREFIX_ONLY" = false ]; then
        new_filename=$(printf "%0${ZERO_PADDING}d) $base_filename" "$i") # add prefix zero padded
    else
        new_filename=$base_filename
    fi
    mv -i -- "$current_filename" "$new_filename" &>/dev/null
    echo $new_filename
    i=$(expr $i + 1)
  done
  cd - 2>&1 >/dev/null
done
