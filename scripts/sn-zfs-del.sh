#Скрипт удалит все старые снимки, тое сть все снимки кроме $1 последних. 

# zroot/ROOT/default
all=$(zfs list -t snapshot | grep -E "default" | wc -l)
zfs list -t snapshot | grep -E "default" | head -n+$(($all -$1 ))| cut -d ' ' -f 1 | xargs -i zfs destroy -r {}
# zroot/data/home
all=$(zfs list -t snapshot | grep -E "home" | wc -l)
zfs list -t snapshot | grep -E "home" | head -n+$(($all -$1 ))| cut -d ' ' -f 1 | xargs -i zfs destroy -r {}
# zroot/data/tank
all=$(zfs list -t snapshot | grep -E "tank" | wc -l)
zfs list -t snapshot | grep -E "tank" | head -n+$(($all -$1 ))| cut -d ' ' -f 1 | xargs -i zfs destroy -r {}
