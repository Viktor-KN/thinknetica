#!/usr/bin/env ruby

require_relative 'instances'
require_relative 'manufacturer'
require_relative 'valid'
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

back = { title: 'Back...', action: :show_menu, params: %i[main_menu] }

main_menu = {
  '1' => { title: 'Stations...', action: :show_menu, params: %i[stations_menu] },
  '2' => { title: 'Trains...', action: :show_menu, params: %i[trains_menu] },
  '3' => { title: 'Wagons...', action: :show_menu, params: %i[wagons_menu] },
  '4' => { title: 'Routes...', action: :show_menu, params: %i[routes_menu] },
  '9' => { title: 'Load seed data', action: :load_seed, params: %i[] },
  '0' => { title: 'Exit', action: :quit, params: %i[] }
}

stations_menu = {
  '0' => back,
  '1' => { title: 'Complete list of stations', action: :show_stations,
           params: %i[stations] },
  '2' => { title: 'Train list on station...', action: :show_station_trains,
           params: %i[stations train_types] },
  '3' => { title: 'New station...', action: :new_station,
           params: %i[] }
}

trains_menu = {
  '0' => back,
  '1' => { title: 'Complete list of trains', action: :show_trains,
           params: %i[trains train_types] },
  '2' => { title: 'New train...', action: :new_train,
           params: %i[train_types] },
  '3' => { title: 'Set train route...', action: :set_train_route,
           params: %i[trains routes] },
  '4' => { title: 'Depart train...', action: :depart_train,
           params: %i[trains directions] }
}

wagons_menu = {
  '0' => back,
  '1' => { title: 'Complete list of wagons', action: :show_wagons,
           params: %i[wagons wagon_types] },
  '2' => { title: 'Wagon list for train...', action: :show_train_wagons,
           params: %i[trains wagon_types] },
  '3' => { title: 'Couple wagon to train...', action: :couple_wagon,
           params: %i[trains wagon_types] },
  '4' => { title: 'Decouple wagon from train...', action: :decouple_wagon,
           params: %i[trains wagons] },
  '5' => { title: 'Occupy wagon seat/volume...', action: :occupy_wagon,
           params: %i[trains wagon_types] }
}

routes_menu = {
  '0' => back,
  '1' => { title: 'Complete list of routes', action: :show_routes,
           params: %i[routes] },
  '2' => { title: 'New route...', action: :new_route,
           params: %i[stations] },
  '3' => { title: 'Add station to route...', action: :add_station_to_route,
           params: %i[routes stations] },
  '4' => { title: 'Remove station from route...', action: :remove_station_from_route,
           params: %i[routes] }
}

menu_list = {
  default: :main_menu,
  main_menu: { title: 'Railway Menu', menu: main_menu },
  stations_menu: { title: 'Stations Menu', menu: stations_menu },
  trains_menu: { title: 'Trains Menu', menu: trains_menu },
  wagons_menu: { title: 'Wagons Menu', menu: wagons_menu },
  routes_menu: { title: 'Routes Menu', menu: routes_menu }
}

train_types = {
  '1' => { title: 'Passenger', class_name: 'PassengerTrain' },
  '2' => { title: 'Cargo', class_name: 'CargoTrain' }
}

wagon_types = {
  '1' => { title: 'Passenger', class_name: 'PassengerWagon',
           measure: 'number of seats', convert: :to_i,
           methods: { init: :seats, occupied: :busy_seats,
                      free: :free_seats, occupy: :take_seat,
                      occupy_param: false } },
  '2' => { title: 'Cargo', class_name: 'CargoWagon',
           measure: 'load volume', convert: :to_f,
           methods: { init: :volume, occupied: :occupied_volume,
                      free: :free_volume, occupy: :occupy_volume,
                      occupy_param: true } }
}

directions = {
  '1' => { title: 'Next station', direction: 'next' },
  '2' => { title: 'Previous station', direction: 'previous' }
}

data = {
  stations: Station.instances,
  routes: Route.instances,
  trains: Train.instances,
  wagons: Wagon.instances,
  train_types: train_types,
  wagon_types: wagon_types,
  directions: directions
}

RailwayMenu.new(menu_list, data).run
