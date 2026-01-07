#!/bin/bash
book=$(find ~/data/tmp/kindle -type f | fzf)
echo "Hi! This is a test message." | mutt -s "Mutt test" snarkrans_tfwkcx@kindle.com -a "$book"
echo send $book
