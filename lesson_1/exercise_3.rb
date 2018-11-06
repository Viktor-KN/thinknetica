#!/usr/bin/env ruby

# Прямоугольный треугольник. Программа запрашивает у пользователя 3 стороны
# треугольника и определяет, является ли треугольник прямоугольным, используя
# теорему Пифагора (www-formula.ru) и выводит результат на экран. Также, если
# треугольник является при этом равнобедренным (т.е. у него равны любые 2
# стороны), то дополнительно выводится информация о том, что треугольник еще и
# равнобедренный. Подсказка: чтобы воспользоваться теоремой Пифагора, нужно
# сначала найти самую длинную сторону (гипотенуза) и сравнить ее значение в
# квадрате с суммой квадратов двух остальных сторон. Если все 3 стороны равны,
# то треугольник равнобедренный и равносторонний, но не прямоугольный.

require_relative 'my_lib'

class Array
  def all_equal?
    self.uniq.length == 1
  end
  def some_equal?
    self.uniq.length == 2
  end
end

class Float
  def equals?(x, tolerance)
    (self - x).abs < tolerance
  end
end

puts "Программа по длинам сторон треугольника вычисляет, является ли он"\
     " прямоугольным."

validate_float = lambda {|str| str.match?(/\A-?+(?=.??\d)\d*\.?\d*\z/) && str.to_f > 0}

a = ask("Введите длину первой стороны треугольника:", :float, &validate_float)
b = ask("Введите длину второй стороны треугольника:", :float, &validate_float)
c = ask("Введите длину третьей стороны треугольника:", :float, &validate_float)

triangle = [a, b, c]

puts "Треугольник равнобедренный" if triangle.some_equal?
if triangle.all_equal?
  puts "Треугольник равносторонний и не может быть прямоугольным"
else
  hypotenuse = triangle.max
  triangle.delete_at(triangle.index(hypotenuse))
  cathetus = triangle
  if (hypotenuse ** 2).equals?(cathetus[0] ** 2 + cathetus[1] ** 2, 0.0000000000001)
    puts "Треугольник прямоугольный"
  else
    puts "Треугольник не прямоугольный"
  end
end
