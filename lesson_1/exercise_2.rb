#!/usr/bin/env ruby

# Площадь треугольника. Площадь треугольника можно вычислить, зная его основание
# (a) и высоту (h) по формуле: 1/2*a*h. Программа должна запрашивать основание и
# высоту треугольника и возвращать его площадь.

puts 'Программа вычисляет площадь треугольника по размеру его основания и ' \
      'высоте.'

print 'Введите длину основания: '
base = gets.strip.to_f
print 'Введите высоту: '
height = gets.strip.to_f

puts "Площадь треугольника с основанием #{base} и высотой #{height} равна" \
     " #{0.5 * base * height}"
