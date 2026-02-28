# Домашняя рендер-ферма для Blender с Flamenco

В этой статье я расскажу о настройке домашней рендер-фермы для **Blender** с использованием **Flamenco** — открытого кроссплатформенного фреймворка для мониторинга и управления рендер-задачами.

## Введение

Фреймворк Flamenco состоит из трёх компонентов:
- **Flamenco Add-on** — связывает Blender и Flamenco
- **Flamenco Manager** — распределяет задачи между компьютерами и предоставляет веб-интерфейс
- **Flamenco Workers** — выполняют рендер на отдельных машинах

Flamenco можно использовать и на одном компьютере: скорость рендера это не увеличит, но добавляет удобства.

На мой взгляд, Flamenco — недооценённый софт. Он прост в развёртывании, не требует сложной инфраструктуры и при этом предоставляет функциональность, сравнимую с коммерческими решениями. Для небольших студий и энтузиастов это отличный способ организовать распределённый рендер без лишних затрат.

## Требования к ферме
- 2 компьютера или больше
- Blender
- Flamenco
- Общая сетевая директория
- Tailscale (опционально, если нужен доступ извне)

Для минимальной конфигурации достаточно одного ПК с установленными Blender и Flamenco.

Я буду использовать **Arch Linux**, но Flamenco также поддерживает **Windows** и **macOS**.

## 1. Установка Tailscale

Установка на Arch Linux:
```bash
sudo pacman -S tailscale
sudo systemctl enable --now tailscaled
sudo tailscale up
```

На безголовом сервере через SSH:
```bash
tailscale up --authkey=tskey-KEY
```

Моя конфигурация:
- **16p** — менеджер
- **m900** — воркер и NFS-сервер

Проверяем соединение:
```bash
ping m900
```
![[attachments/2026-01-15_17-34.png]]

## 2. Установка NFS-шары
```bash
sudo pacman -S nfs-utils
sudo systemctl enable --now nfs-server
```
Для ZFS:
```bash
zfs set sharenfs=on zroot/data/tank
sudo systemctl enable --now zfs-share.service
```
Создаём директорию:
```bash
mkdir -p ~/data/tmp/nfs_flamenco
```
Монтирование на менеджере:
```bash
sudo pacman -S nfs-utils
mkdir -p ~/data/tmp/nfs_flamenco
sudo mount -t nfs m900:$HOME/data/tmp/nfs_flamenco $HOME/data/tmp/nfs_flamenco
mount | grep nfs
```
![[attachments/2026-01-15_17-40.png]]

## 3. Установка Blender и Flamenco

1. Устанавливаем Blender и [Flamenco](https://flamenco.blender.org/download/)
2. Запускаем flamenco-worker:
```bash
./flamenco-worker -manager http://100.90.50.50:8080
```
3. Запускаем flamenco-manager на 16p

![[attachments/2026-01-15_17-54.png]]

## 4. Автоматизация запуска
### Flamenco Worker
```ini
[Unit]
Description=Flamenco Worker connecting to Manager
Documentation=http://100.90.50.50:8080/
After=network.target
[Service]
Type=simple
CPUSchedulingPolicy=idle
Nice=19
WorkingDirectory=/home/snark/data/soft/flamenco_beta
ExecStart=/home/snark/data/soft/flamenco_beta/flamenco-worker   -manager http://100.90.50.50:8080/   -restart-exit-code 47
RestartForceExitStatus=47
Restart=on-failure
EnvironmentFile=-/etc/default/locale
[Install]
WantedBy=multi-user.target
```
### Flamenco Manager
```ini
[Unit]
Description=Flamenco Manager service
After=network.target
[Service]
User=snark
WorkingDirectory=/home/snark/data/soft/flamenco_beta
ExecStart=/home/snark/data/soft/flamenco_beta/flamenco-manager
Restart=always
RestartSec=5s
[Install]
WantedBy=multi-user.target
```
### NetworkManager для Tailscale
```ini
[keyfile]
unmanaged-devices=interface-name:tailscale0
```
### Монтирование NFS через fstab
```fstab
m900:/home/snark/data/tmp/nfs_flamenco  /home/snark/data/tmp/nfs_flamenco  nfs  rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,fatal_neterrors=none,proto=tcp,timeo=600,retrans=2,sec=sys,_netdev,x-systemd.automount,nofail  0  0
```

## 5. Полезные материалы и ссылки
- [Flamenco — документация](https://flamenco.blender.org/usage/quickstart)
- [Arch Wiki — Tailscale](https://wiki.archlinux.org/title/Tailscale)
- [Arch Wiki — NFS](https://wiki.archlinux.org/title/NFS)
- [Arch Wiki — systemd](https://wiki.archlinux.org/title/systemd)
