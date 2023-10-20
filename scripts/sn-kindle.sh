#!/bin/bash
# calibre

TARGET=~/kindle/
 
inotifywait -m -e create -e moved_to --format "%f" $TARGET \
        | while read FILENAME
                do
                        echo Detected $FILENAME, moving to kindle
                        #ebook-convert "/home/snark/kindle/$FILENAME" "/home/snark/kindle-send/${FILENAME%.*}.rtf"
                        echo "Hi! This is a test message." | mutt -s "Mutt test" snarkrans_tfwkcx@kindle.com -a "/home/snark/kindle-send/${FILENAME%.*}.rtf"
                        echo "${FILENAME%.*}.rtf send to kindle" | systemd-cat
                
                done
