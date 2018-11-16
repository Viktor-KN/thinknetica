#!/usr/bin/env ruby

require_relative 'instances'
require_relative 'manufacturer'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'menu'
require_relative 'railway_menu'

main_menu = {
  '1' => { title: 'New station', action: :add_station,
           params: %i[] },
  '2' => { title: 'New train', action: :add_train,
           params: %i[train_types] },
  '3' => { title: 'Routes (New/Manage)', action: :show_menu,
           params: %i[routes_menu] },
  '4' => { title: 'Set train route', action: :set_train_route,
           params: %i[trains routes] },
  '5' => { title: 'Couple wagon to train', action: :add_wagon,
           params: %i[trains wagon_types] },
  '6' => { title: 'Decouple wagon from train', action: :remove_wagon,
           params: %i[trains] },
  '7' => { title: 'Depart train', action: :depart_train,
           params: %i[trains directions] },
  '8' => { title: 'Station and train list', action: :show_stations,
           params: %i[stations train_types] },
  '9' => { title: 'Exit', action: :quit,
           params: %i[] }
}

routes_menu = {
  '0' => { title: 'Back', action: :show_menu,
           params: %i[main_menu] },
  '1' => { title: 'New route', action: :add_route,
           params: %i[stations] },
  '2' => { title: 'Add station to route', action: :add_route_station,
           params: %i[routes stations] },
  '3' => { title: 'Remove station from route', action: :remove_route_station,
           params: %i[routes] }
}

menu_list = {
  default: :main_menu,
  main_menu: main_menu,
  routes_menu: routes_menu
}

train_types = {
  '1' => { title: 'Passenger', class_name: 'PassengerTrain' },
  '2' => { title: 'Cargo', class_name: 'CargoTrain' }
}

wagon_types = {
  '1' => { title: 'Passenger wagon', class_name: 'PassengerWagon' },
  '2' => { title: 'Cargo wagon', class_name: 'CargoWagon' }
}

directions = {
  '1' => { title: 'Next station', direction: 'next' },
  '2' => { title: 'Previous station', direction: 'previous' }
}

data = {
  stations: Station.instances,
  routes: Route.instances,
  trains: Train.instances,
  train_types: train_types,
  wagon_types: wagon_types,
  directions: directions
}

RailwayMenu.new('Railroad Managment', menu_list, data).run
