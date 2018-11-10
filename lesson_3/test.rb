#!/usr/bin/env ruby

require_relative 'station'
require_relative 'route'
require_relative 'train'

def show_route(route)
  route.stations.each do |station|
    print "#{station.name}#{station == route.stations.last ? "\n" : ' - '}"
  end
  print "\n"
end

def show_train(train)
  puts "Train: #{train.number} Type: #{train.type}, Station: #{train.station.name}"
  puts "Prev: #{train.previous_station.name}, Next: #{train.next_station.name}"
  puts "Speed: #{train.speed}, Wagons: #{train.wagons}\n\n"
end

def show_trains(station, type = :any)
  station.trains(type).each { |train| show_train(train) }
end

s1 = Station.new('One')
s2 = Station.new('Two')
s3 = Station.new('Three')
s4 = Station.new('Four')
s5 = Station.new('Five')
s6 = Station.new('Six')

r1 = Route.new(s1, s5)
r2 = Route.new(s1, s4)

r1.add_station(s2)
r1.add_station(s4)
r1.add_station(s6)

r2.add_station(s3)
r2.add_station(s5)

train1 = Train.new(123, :passenger, 5)
train2 = Train.new(234, :freight, 10)

train1.route = r1
train2.route = r2

print "Routes---------------------------------------------\n\n"
show_route(r1)
show_route(r2)

print "Remove station6 from route1------------------------\n\n"
r1.remove_station(s6)
show_route(r1)

print "All trains init position---------------------------\n\n"
show_trains(s1)

print "Passanger trains init position---------------------\n\n"
show_trains(s1, :passenger)

print "Freight trains init position  ---------------------\n\n"
show_trains(s1, :freight)

print "Move train1 to previous station (shouldn't move)---\n\n"
train1.speed = 60
train1.move_to_previous
show_train(train1)

print "Move train2 to next station------------------------\n\n"
train2.speed = 75
train2.move_to_next
show_train(train2)

print "Is train2 really on station Three------------------\n\n"
show_trains(s3)

print "Move train1 to last station------------------------\n\n"
3.times { train1.move_to_next }
show_train(train1)

print "Checking station1 for trains (should be empty)-----\n\n"
show_trains(s1)

print "Uncouple wagon from train2 while it move-----------\n\n"
train2.remove_wagon
show_train(train2)

print "Uncouple wagon from train2 when stop---------------\n\n"
train2.stop
train2.remove_wagon
show_train(train2)

print "Couple 2 wagons to train1 while stopped------------\n\n"
train1.stop
2.times { train1.add_wagon }
show_train(train1)

print "Move train1 to next station (shouldn't move)-------\n\n"
train1.move_to_next
show_train(train1)
