#!/usr/bin/env ruby

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

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

menus = {
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

objects_list = {
  stations: [],
  routes: [],
  trains: [],
  train_types: train_types,
  wagon_types: wagon_types,
  directions: directions
}

def quit
  puts 'Пока!'
  exit(0)
end

def ask(question, variants)
  if variants.class == Hash
    variants.each { |key, val| puts "#{key}.\t#{val[:title]}" }
    print question
    until variants.key?(variant = gets.strip)
      print 'Неверный ввод, повторите выбор: '
    end
  else
    variants.each.with_index(1) { |var, index| puts "#{index}.\t#{var}" }
    print question
    until (0..variants.size - 1).cover?(variant = gets.to_i - 1)
      print 'Неверный ввод, повторите выбор: '
    end
  end
  variant
end

def add_station(station_list)
  print 'Введите название станции: '
  name = gets.strip.capitalize
  if station_list.any? { |station| station.name == name }
    print "\nСтанция с таким именем уже существует!\n"
  else
    station_list << Station.new(name)
    print "\nСтанция успешно добавлена.\n"
  end
end

def add_train(train_list, train_types)
  type = ask('Выберите тип поезда: ', train_types)
  print 'Введите номер поезда: '
  number = gets.strip
  if train_list.any? { |train| train.number == number }
    print "\nПоезд с таким номером уже существует!\n"
  else
    train_list << Kernel.const_get(train_types[type][:class_name].to_sym)
                        .new(number)
    print "\nПоезд успешно добавлен.\n"
  end
end

def add_route(route_list, station_list)
  if station_list.size < 2
    print "\nДля нового маршрута нужно создать минимум 2 станции!\n"
    return
  end
  first = station_list[ask('Выберите начальную станцию: ', station_list)]
  last = station_list[ask('Выберите конечную станцию: ', station_list)]
  route_list << Route.new(first, last)
  print "\nМаршрут успешно добавлен.\n"
end

def show_stations(station_list, train_types)
  if station_list.size.zero?
    print "\nПусто.\n"
    return
  end
  station_list.each do |station|
    puts "\nСтанция #{station}:"
    train_types.each_value do |type|
      trains = station.trains.select { |t| t.class.to_s == type[:class_name] }
      puts "  #{type[:plural]} поезда:"
      if trains.size.zero?
        puts '    нет'
      else
        trains.each do |train|
          puts "    Номер: #{train} Вагонов: #{train.wagons.size}"
        end
      end
    end
  end
end

def set_train_route(train_list, route_list)
  if train_list.size.zero?
    print "\nНе найдено ни одного поезда!\n"
    return
  end
  if route_list.size.zero?
    print "\nНе найдено ни одного маршрута!\n"
    return
  end

  train = train_list[ask('Выберите поезд: ', train_list)]
  route = route_list[ask('Выберите маршрут: ', route_list)]

  train.route = route
  print "\nМаршрут успешно установлен.\n"
end

def add_wagon(train_list, wagon_types)
  if train_list.size.zero?
    print "\nНе найдено ни одного поезда!\n"
    return
  end

  train = train_list[ask('Выберите поезд: ', train_list)]
  wagon_type = wagon_types[ask('Выберите тип вагона: ', wagon_types)]

  if wagon_type[:allowed_trains].include?(train.class.to_s)
    wagon = Kernel.const_get(wagon_type[:class_name].to_sym).new
    train.add_wagon(wagon)
    print "\nВагон успешно прицеплен.\n"
  else
    print "\nДанный тип вагона не может быть прицеплен к поезду #{train}!\n"
  end
end

def remove_wagon(train_list)
  if train_list.size.zero?
    print "\nНе найдено ни одного поезда!\n"
    return
  end

  train = train_list[ask('Выберите поезд: ', train_list)]

  if train.wagons.size.zero?
    print "\nУ поезда #{train} нет ни одного вагона!\n"
  else
    train.remove_wagon
    print "\nВагон успешно отцеплен.\n"
  end
end

def add_route_station(route_list, station_list)
  if station_list.size.zero?
    print "\nНе найдено ни одной станции!\n"
    return
  end
  if route_list.size.zero?
    print "\nНе найдено ни одного маршрута!\n"
    return
  end

  route = route_list[ask('Выберите маршрут: ', route_list)]
  station = station_list[ask('Выберите станцию: ', station_list)]

  if route.stations.include?(station)
    print "\nТакая станция уже есть в маршруте!\n"
  else
    route.add_station(station)
    print "\nСтанция успешно добавлена в маршрут.\n"
  end
end

def remove_route_station(route_list)
  if route_list.size.zero?
    print "\nНе найдено ни одного маршрута!\n"
    return
  end

  routes = route_list.select { |route| route.stations.size > 2 }

  if routes.size.zero?
    print "\nНе найдено ни одного маршрута с промежуточными станциями!\n"
    return
  end

  route = routes[ask('Выберите маршрут: ', routes)]
  stations = route.stations[1...-1]
  station = stations[ask('Выберите станцию: ', stations)]

  route.remove_station(station)
  print "\nСтанция успешно удалена.\n"
end

def depart_train(train_list, directions)
  if train_list.size.zero?
    print "\nНе найдено ни одного поезда!\n"
    return
  end

  train = train_list[ask('Выберите поезд: ', train_list)]

  if train.route.nil?
    print "\nПоезд еще в заводском депо. Назначьте сначала маршрут!\n"
    return
  end

  print "\n#{train.route.to_s(train.station)}\n"

  direction = directions[ask('Выберите направление: ', directions)][:direction]

  direction_check_method = "#{direction}_station".to_sym
  direction_move_method = "move_to_#{direction}".to_sym
  direction_station = train.send(direction_check_method)
  if train.station == direction_station
    print "\nВ этом направлении движение невозможно!\n"
    return
  else
    train.send(direction_move_method)
    print "\nПоезд #{train} успешно отбыл на станцию #{direction_station}.\n"
  end
end

current_menu = :main_menu
loop do
  print "\nМеню:\n"
  choice = ask('Ваш выбор: ', menus[current_menu])

  if menus[current_menu][choice][:action] == :show_menu
    current_menu = menus[current_menu][choice][:params][0]
    next
  else
    action = menus[current_menu][choice][:action]
    params = []
    menus[current_menu][choice][:params].each do |param|
      params << objects_list[param]
    end
    send(action, *params)
  end
end
