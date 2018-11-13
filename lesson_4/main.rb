#!/usr/bin/env ruby

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'menu'
require_relative 'railway_menu'

main_menu = {
  '1' => { title: 'Создать станцию', action: :add_station,
           params: %i[stations] },
  '2' => { title: 'Создать поезд', action: :add_train,
           params: %i[trains train_types] },
  '3' => { title: 'Маршруты (создать/управлять)', action: :show_menu,
           params: %i[routes_menu] },
  '4' => { title: 'Назначить маршрут поезду', action: :set_train_route,
           params: %i[trains routes] },
  '5' => { title: 'Добавить вагон к поезду', action: :add_wagon,
           params: %i[trains wagon_types] },
  '6' => { title: 'Отцепить вагон от поезда', action: :remove_wagon,
           params: %i[trains] },
  '7' => { title: 'Отправить поезд', action: :depart_train,
           params: %i[trains directions] },
  '8' => { title: 'Список станций и поездов на них', action: :show_stations,
           params: %i[stations train_types] },
  '9' => { title: 'Выход', action: :quit,
           params: %i[] }
}

routes_menu = {
  '0' => { title: 'Назад', action: :show_menu,
           params: %i[main_menu] },
  '1' => { title: 'Создать маршрут', action: :add_route,
           params: %i[routes stations] },
  '2' => { title: 'Добавить станцию в маршрут', action: :add_route_station,
           params: %i[routes stations] },
  '3' => { title: 'Удалить станцию из маршрута', action: :remove_route_station,
           params: %i[routes] }
}

menu_list = {
  default: :main_menu,
  main_menu: main_menu,
  routes_menu: routes_menu
}

train_types = {
  '1' => { title: 'Пассажирский', plural: 'Пассажирские',
           class_name: 'PassengerTrain' },
  '2' => { title: 'Грузовой', plural: 'Грузовые',
           class_name: 'CargoTrain' }
}

wagon_types = {
  '1' => { title: 'Пассажирский вагон', class_name: 'PassengerWagon',
           allowed_trains: ['PassengerTrain'] },
  '2' => { title: 'Грузовой вагон', class_name: 'CargoWagon',
           allowed_trains: ['CargoTrain'] }
}

directions = {
  '1' => { title: 'Следующая станция', direction: 'next' },
  '2' => { title: 'Предыдущая станция', direction: 'previous' }
}

data = {
  stations: [],
  routes: [],
  trains: [],
  train_types: train_types,
  wagon_types: wagon_types,
  directions: directions
}

RailwayMenu.new('Управление Ж/Д', menu_list, data).run
