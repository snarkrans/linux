all=$(sudo btrfs subv list / | grep -E "/home.|/root." | wc -l)
save=30
sudo btrfs subv list / | grep -E "/home.|/root." | head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i echo /{} | xargs -i sudo btrfs subvolume delete {}
exit

Скрипт удалит все старые снимки, тое сть все снимки кроме 30 последних. 
