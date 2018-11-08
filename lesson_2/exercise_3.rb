#!/usr/bin/env ruby

# Заполнить массив числами фибоначчи до 100

arr = [0, 1]
while (sum = arr.last(2).sum) < 100
  arr << sum
end

p arr
