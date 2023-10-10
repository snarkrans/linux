#!/bin/bash
# Зависимости: gnuplot

# Путь к файлу, в который будет сохранен график
output_file="battery_charge.png"

# Функция для получения данных о заряде батареи
get_battery_data() {
    upower -i $(upower -e | grep battery) | awk '/percentage/ {print $2}' | tr -d '%'
}

# Функция для построения графика
create_battery_graph() {
    echo "set terminal png size 800,400" > plot.script
    echo "set output '$output_file'" >> plot.script
    echo "set title 'График заряда батареи'" >> plot.script
    echo "set xlabel 'Время'" >> plot.script
    echo "set ylabel 'Заряд батареи (%)'" >> plot.script
    echo "set yrange [0:100]" >> plot.script
    echo "plot 'plot.data' using 1:2 with lines title 'Заряд батареи'" >> plot.script
    echo "$(date +%H:%M:%S) $(get_battery_data)" >> plot.data
    sleep 30m
    gnuplot -p -c plot.script
}

# Вызываем функцию для создания графика
for i in `seq 10`; do create_battery_graph; done
rm plot.data
rm plot.script