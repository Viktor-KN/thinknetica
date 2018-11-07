#!/usr/bin/env ruby

# Заполнить массив числами фибоначчи до 100

arr = [0, 1]
loop do
  sum = arr.last(2).sum
  break if sum > 100

  arr << sum
end

p arr
