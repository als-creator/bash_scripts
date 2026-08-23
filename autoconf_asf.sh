#!/bin/bash

# Этап 1: Создание файла сервиса с использованием sudo tee
echo "Создание файла сервиса..."
sudo tee /etc/systemd/system/asf.service << EOF
[Unit]
Description=ArchiSteamFarm
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/$USER/.apps/ASF/
ExecStart=/home/$USER/.apps/ASF/ArchiSteamFarm/
User=als
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

# Проверяем успешность создания файла
if [ "$?" -eq 0 ]; then
    echo "Файл сервиса успешно создан."
else
    echo "Ошибка при создании файла сервиса!"
    exit 1
fi

# Этап 2: Установка прав на выполнение файла программы
echo "Установка прав на выполнение..."
chmod +x /home/$USER/.apps/ASF/ArchiSteamFarm/

# Проверяем успешность установки прав
if [ "$?" -eq 0 ]; then
    echo "Права установлены успешно."
else
    echo "Ошибка при установке прав!"
    exit 1
fi

# Обновление конфигурации systemd и включение сервиса
echo "Обновление конфигурации systemd и включение сервиса..."
sudo systemctl daemon-reload
sudo systemctl enable --now asf.service

# Проверяем статус сервиса
systemctl is-active asf.service &>/dev/null
if [ "$?" -eq 0 ]; then
    echo "Сервис запущен успешно."
else
    echo "Ошибка при запуске сервиса!"
    exit 1
fi
sudo systemctl status asf.service

exit 0
