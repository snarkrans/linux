all=$(sudo btrfs subv list / | grep -E "/home.|/root." | wc -l)
save=30
echo old snapshots 
sudo btrfs subv list / | grep -E "/home.|/root." | head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i echo /{} | xargs -i echo {}
exit

Скрипт покажет старые снимки, то есть все снимки кроме 30 последних. 
