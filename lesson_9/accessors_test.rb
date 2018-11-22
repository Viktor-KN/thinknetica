require_relative 'accessors'
class Foo
  include Accessors

  attr_accessor_with_history :a, :b
  strong_attr_accessor :str, String
end

foo = Foo.new

puts 'Doing: 20.times { |i| foo.a = i if i.even? }'
20.times { |i| foo.a = i if i.even? }
puts 'Doing: 20.times { |i| foo.b = i if i.odd? }'
20.times { |i| foo.b = i if i.odd? }

print "foo.a: #{foo.a}\nfoo.a_history: "
p foo.a_history
print "foo.b: #{foo.b}\nfoo.b_history: "
p foo.b_history

puts 'Trying to do foo.str = 123'
begin
  foo.str = 123
rescue ArgumentError => e
  puts "Oops, catched error:\n    #{e.message}\n    #{e.backtrace}"
end
puts "foo.str: #{foo.str.nil? ? 'nil' : foo.str}"

puts "Trying to do foo.str = 'string'"
foo.str = 'string'

puts "foo.str: #{foo.str}"
