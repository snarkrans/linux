#!/bin/bash
TARGET=~/kindle/
 
inotifywait -m -e create -e moved_to --format "%f" $TARGET \
        | while read FILENAME
                do
                        echo Detected $FILENAME, moving to kindle
                        ebook-convert "/home/snark/kindle/$FILENAME" "/home/snark/kindle-send/${FILENAME%.*}.rtf"
                        echo "Hi! This is a test message." | mutt -s "Mutt test" user@kindle.com -a "/home/snark/kindle-send/${FILENAME%.*}.rtf"
                        echo "${FILENAME%.*}.rtf send to kindle" | systemd-cat
                
                done
                
Скрипт отслеживает изменения в директори ~/kindle, конвертирует новый файл в rtf и отправляет на почтовый яшик букридера. Просто скопируйте книжку в 
директорию ~/kindle и она появится на устройстве.
  
Скрипт можно запустить через крон:  
EDITOR=nvim crontab -e
@reboot sleep 3 && /home/snark/snl/sc/sn-kindle.sh &
 
Зависимости - calibre, mutt, inotify-tools
Конфиг для muut лежит в файле muttrc

Проверка журнала:
journalctl -b | grep "send to kindle"
