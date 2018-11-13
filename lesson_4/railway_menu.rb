class RailwayMenu < Menu
  protected

  def your_choice
    'Ваш выбор: '
  end

  def incorrect_choice
    'Неверный выбор. Повторите: '
  end

  def incorrect_value
    'Неверное значение. Повторите ввод: '
  end

  def quit
    puts 'Завершение работы!'
    exit(0)
  end

  def add_station(station_list)
    name = ask('Введите название станции: ').capitalize
    if station_list.any? { |station| station.name.casecmp(name).zero? }
      print_nn 'Станция с таким именем уже существует!'
    else
      station_list << Station.new(name)
      print_nn 'Станция успешно добавлена.'
    end
  end

  def add_train(train_list, train_types)
    type = ask('Выберите тип поезда: ', train_types)
    number = ask('Введите номер поезда: ')

    if train_list.any? { |train| train.number == number }
      print_nn 'Поезд с таким номером уже существует!'
    else
      train_list << Kernel.const_get(train_types[type][:class_name]).new(number)
      print_nn 'Поезд успешно добавлен.'
    end
  end

  def add_route(route_list, station_list)
    if station_list.size < 2
      return print_nn 'Для нового маршрута нужно создать минимум 2 станции!'
    end

    first = station_list[ask('Выберите начальную станцию: ', station_list)]
    last = station_list[ask('Выберите конечную станцию: ', station_list)]
    route_list << Route.new(first, last)
    print_nn 'Маршрут успешно добавлен.'
  end

  def show_stations(station_list, train_types)
    return print_nn 'Пусто.' if station_list.size.zero?

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
    return print_nn 'Не найдено ни одного поезда!' if train_list.size.zero?
    return print_nn 'Не найдено ни одного маршрута!' if route_list.size.zero?

    train = train_list[ask('Выберите поезд: ', train_list)]
    route = route_list[ask('Выберите маршрут: ', route_list)]

    train.route = route
    print_nn 'Маршрут успешно установлен.'
  end

  def add_wagon(train_list, wagon_types)
    return print_nn 'Не найдено ни одного поезда!' if train_list.size.zero?

    train = train_list[ask('Выберите поезд: ', train_list)]
    wagon_type = wagon_types[ask('Выберите тип вагона: ', wagon_types)]

    if wagon_type[:allowed_trains].include?(train.class.to_s)
      wagon = Kernel.const_get(wagon_type[:class_name]).new
      train.add_wagon(wagon)
      print_nn 'Вагон успешно прицеплен.'
    else
      print_nn "Данный тип вагона не может быть прицеплен к поезду #{train}!"
    end
  end

  def remove_wagon(train_list)
    return print_nn 'Не найдено ни одного поезда!' if train_list.size.zero?

    train = train_list[ask('Выберите поезд: ', train_list)]

    if train.wagons.size.zero?
      print_nn "У поезда #{train} нет ни одного вагона!"
    else
      train.remove_wagon
      print_nn 'Вагон успешно отцеплен.'
    end
  end

  def add_route_station(route_list, station_list)
    return print_nn 'Не найдено ни одной станции!' if station_list.size.zero?
    return print_nn 'Не найдено ни одного маршрута!' if route_list.size.zero?

    route = route_list[ask('Выберите маршрут: ', route_list)]
    station = station_list[ask('Выберите станцию: ', station_list)]

    if route.stations.include?(station)
      print_nn 'Такая станция уже есть в маршруте!'
    else
      route.add_station(station)
      print_nn 'Станция успешно добавлена в маршрут.'
    end
  end

  def remove_route_station(route_list)
    return print_nn 'Не найдено ни одного маршрута!' if route_list.size.zero?

    routes = route_list.select { |route| route.stations.size > 2 }

    if routes.size.zero?
      print_nn 'Не найдено ни одного маршрута с промежуточными станциями!'
      return
    end

    route = routes[ask('Выберите маршрут: ', routes)]
    stations = route.stations[1...-1]
    station = stations[ask('Выберите станцию: ', stations)]
    route.remove_station(station)

    print_nn 'Станция успешно удалена.'
  end

  def depart_train(train_list, directions)
    return print_nn 'Не найдено ни одного поезда!' if train_list.size.zero?

    train = train_list[ask('Выберите поезд: ', train_list)]

    if train.route.nil?
      print_nn 'Поезд еще в заводском депо. Назначьте сначала маршрут!'
      return
    end

    print_nn "#{train.route.to_s(train.station)}"

    direction = directions[ask('Выберите направление: ', directions)][:direction]

    direction_check_method = "#{direction}_station"
    direction_move_method = "move_to_#{direction}"
    direction_station = train.send(direction_check_method)

    if train.station == direction_station
      print_nn 'В этом направлении движение невозможно!'
      return
    else
      train.send(direction_move_method)
      print_nn "Поезд #{train} успешно отбыл на станцию #{direction_station}."
    end
  end
end
