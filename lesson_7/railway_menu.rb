class RailwayMenu < Menu
  private

  def quit
    puts 'Exiting!'
    exit(0)
  end

  def stop_answer?(answer)
    answer.is_a?(String) && answer.casecmp('stop').zero?
  end

  def find_type(class_name, type_list)
    class_name = class_name.to_s unless class_name.is_a?(String)
    type = nil
    type_list.each_value do |type_entry|
      if type_entry[:class_name] == class_name
        type = type_entry
        break
      end
    end
    type
  end

  def random_wagon_number
    "#{Random.rand(1000..9999)}-#{Random.rand(1000..9999)}"
  end

  def show_stations(station_list)
    return print_nn 'Station list is empty.' if station_list.size.zero?

    station_list.each do |station|
      printf("Name: %-20s Trains: %d\n", station.name, station.trains.size)
    end
  end

  def show_station_trains(station_list, train_types)
    return print_nn 'Station list is empty.' if station_list.size.zero?

    station = station_list[ask('Choose station: ', station_list)]
    return print_nn "No trains on station #{station}." if station.trains.size.zero?

    station.each_train { |train| show_train(train, train_types) }
  end

  def new_station
    name = ask("Enter the name of new station (or 'stop'): ")
    return if stop_answer?(name)

    Station.new(name)
    print_nn 'Station successfully created.'
  rescue RuntimeError => e
    puts "Error: #{e.message}"
    retry
  end

  def show_train(train, train_types)
    number = train.number
    type = find_type(train.class, train_types)
    wagons = train.wagons.size
    station = train.station ? train.station.name : 'Manufacturer Depo'
    printf("Number: %-8s Type: %-12s Wagons: %-3d Station: %s\n",
           number, type[:title], wagons, station)
  end

  def show_trains(train_list, train_types)
    return print_nn 'Train list is empty.' if train_list.size.zero?

    train_list.each { |train| show_train(train, train_types) }
  end

  def new_train(train_types)
    type = ask('Select train type: ', train_types)
    begin
      number = ask("Enter train number (or 'stop'): ")
      return if stop_answer?(number)

      Object.const_get(train_types[type][:class_name]).new(number)
      print_nn "Train #{number} successfully created."
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
      retry
    end
  end

  def set_train_route(train_list, route_list)
    return print_nn 'Error: No trains found.' if train_list.size.zero?
    return print_nn 'Error: No routes found.' if route_list.size.zero?

    train = train_list[ask('Choose train: ', train_list)]
    route = route_list[ask('Choose route: ', route_list)]

    train.route = route
    print_nn "Route for train #{train} successfully set."
  end

  def depart_train(train_list, directions)
    return print_nn 'Error: No trains found.' if train_list.size.zero?

    train = train_list[ask('Choose train: ', train_list)]

    return print_nn "Error: No route set for #{train}." unless train.route

    print_nn train.route.to_s(train.station)

    direction = directions[ask('Choose direction: ', directions)][:direction]

    direction_check_method = "#{direction}_station"
    direction_move_method = "move_to_#{direction}"
    begin
      direction_station = train.send(direction_check_method)
      train.send(direction_move_method)
      print_nn "Train #{train} successfully departed to #{direction_station}."
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
    end
  end

  def show_wagon(wagon, wagon_types)
    number = wagon.number
    type = find_type(wagon.class, wagon_types)
    free_amount = wagon.send type[:methods][:free]
    occupied_amount = wagon.send type[:methods][:occupied]
    measure = type[:measure].capitalize
    df = type[:convert] == :to_i ? '-8d' : '-8.2f'
    printf("Number: %-12s Type: %-12s %16s free: %#{df} Occupied: %#{df}\n",
           number, type[:title], measure, free_amount, occupied_amount)
  end

  def show_wagons(wagon_list, wagon_types)
    return print_nn 'Wagon list is empty.' if wagon_list.size.zero?

    wagon_list.each { |wagon| show_wagon(wagon, wagon_types) }
  end

  def show_train_wagons(train_list, wagon_types)
    return print_nn 'Train list is empty.' if train_list.size.zero?

    train = train_list[ask('Choose train: ', train_list)]
    return print_nn "No wagons attached to train #{train}." \
                    if train.wagons.size.zero?

    train.each_wagon { |wagon| show_wagon(wagon, wagon_types) }
  end

  def occupy_wagon(train_list, wagon_types)
    return print_nn 'Train list is empty.' if train_list.size.zero?

    train = train_list[ask('Choose train: ', train_list)]
    return print_nn "No wagons coupled to train #{train}" if train.wagons.size.zero?

    wagon = train.wagons[ask('Choose wagon: ', train.wagons)]
    type = find_type(wagon.class, wagon_types)
    method = type[:methods][:occupy]

    begin
      if type[:methods][:occupy_param]
        param = ask("Enter #{type[:measure]}: ").send type[:convert]
        wagon.send method, param
      else
        wagon.send method
      end
      print_nn 'Operation was successfull.'
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
    end
  end

  def show_routes(route_list)
    return print_nn 'Route list is empty.' if route_list.size.zero?

    route_list.each { |route| puts route }
  end

  def new_route(station_list)
    if station_list.size < 2
      return print_nn 'Error: To define new route, you must create at least 2' \
                      ' stations.'
    end

    first = station_list[ask('Choose first station: ', station_list)]
    last = station_list[ask('Choose last station: ', station_list)]
    begin
      Route.new(first, last)
      print_nn 'Route successfully created.'
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
    end
  end

  def new_wagon(train, wagon_types)
    wagon_type = wagon_types[ask('Choose wagon type: ', wagon_types)]

    unless train.allowed_wagon?(wagon_type[:class_name].to_sym)
      return print_nn "Error: Can't couple #{wagon_type[:title]} wagon to" \
                      " train #{train}"
    end

    begin
      param =
        ask("Enter #{wagon_type[:measure]} for #{wagon_type[:title]} wagon " \
            "(or 'stop'): ")
      return 'stop' if stop_answer?(param)

      param = param.send wagon_type[:convert]
      Object.const_get(wagon_type[:class_name]).new(random_wagon_number, param)
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
      retry
    end
  end

  def couple_wagon(train_list, wagon_types)
    return print_nn 'Error: No trains found.' if train_list.size.zero?

    train = train_list[ask('Choose train: ', train_list)]
    wagon = new_wagon(train, wagon_types)
    return if wagon.nil? || stop_answer?(wagon)

    begin
      train.add_wagon(wagon)
      print_nn "Wagon #{wagon} successfully coupled to #{train}."
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
    end
  end

  def decouple_wagon(train_list, wagon_list)
    return print_nn 'Error: No trains found.' if train_list.size.zero?

    train = train_list[ask('Choose train: ', train_list)]

    begin
      wagon = train.remove_wagon
      wagon_list.delete(wagon)
      print_nn 'Wagon successfully decoupled.'
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
    end
  end

  def add_station_to_route(route_list, station_list)
    return print_nn 'Error: No stations found.' if station_list.size.zero?
    return print_nn 'Error: No routes found.' if route_list.size.zero?

    route = route_list[ask('Choose route: ', route_list)]
    station = station_list[ask('Choose station: ', station_list)]

    begin
      route.add_station(station)
      print_nn "Station #{station} sucessfully added to route."
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
    end
  end

  def remove_station_from_route(route_list)
    return print_nn 'Error: No routes found.' if route_list.size.zero?

    route = route_list[ask('Choose route: ', route_list)]
    stations = route.stations
    station = stations[ask('Choose station: ', stations)]

    begin
      route.remove_station(station)
      print_nn "Station #{station} successfuly removed from route."
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
    end
  end

  def load_seed
    s1 = Station.new('Moscow')
    s2 = Station.new('St.Peterburg')
    s3 = Station.new('Novosibirsk')
    s4 = Station.new('Chelyabinsk')
    s5 = Station.new('Khabarovsk')

    t1 = PassengerTrain.new('PAS-01')
    t2 = PassengerTrain.new('PAS-02')
    t3 = CargoTrain.new('CAR-01')
    t4 = CargoTrain.new('CAR-02')

    r1 = Route.new(s1, s5)
    r2 = Route.new(s3, s1)

    r1.add_station(s4)
    r2.add_station(s2)

    t1.route = r1
    t2.route = r2

    w1 = PassengerWagon.new(random_wagon_number, 120)
    w2 = PassengerWagon.new(random_wagon_number, 110)
    w3 = PassengerWagon.new(random_wagon_number, 115)
    w4 = CargoWagon.new(random_wagon_number, 6000)
    w5 = CargoWagon.new(random_wagon_number, 7000)
    w6 = CargoWagon.new(random_wagon_number, 5000)

    t1.add_wagon(w1)
    t1.add_wagon(w2)
    t1.add_wagon(w3)

    t3.add_wagon(w4)
    t3.add_wagon(w5)
    t3.add_wagon(w6)

    65.times { w1.take_seat }
    43.times { w2.take_seat }
    88.times { w3.take_seat }

    w4.occupy_volume(123.45)
    w5.occupy_volume(1234)
    w6.occupy_volume(432.1)

    menu_list[:main_menu][:menu].delete('9')
    print_nn 'Seed data successfully loaded.'
  end
end
