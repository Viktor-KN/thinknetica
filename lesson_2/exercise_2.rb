#!/usr/bin/env ruby

# Заполнить массив числами от 10 до 100 с шагом 5

arr = (10..100).select { |num| (num % 5).zero? }

p arr
