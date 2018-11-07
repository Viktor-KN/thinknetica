#!/usr/bin/env ruby

# Заполнить хеш гласными буквами, где значением будет являтся порядковый номер
# буквы в алфавите

vowels = %w[a e i o u]

vowels_hash = {}
vowels.each { |char| vowels_hash[char] = char.ord - 96 }

p vowels_hash
