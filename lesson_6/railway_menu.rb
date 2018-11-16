class RailwayMenu < Menu
  protected

  def quit
    puts 'Exiting!'
    exit(0)
  end

  def stop?(answer)
    answer.casecmp('stop').zero?
  end

  def add_station
    name = ask("Enter the name of new station (or 'stop'): ")
    return if stop?(name)

    Station.new(name)
    print_nn 'Station successfully added.'
  rescue RuntimeError => e
    puts "Error: #{e.message}"
    retry
  end

  def add_train(train_types)
    type = ask('Select train type: ', train_types)
    begin
      number = ask("Enter train number (or 'stop'): ")
      return if stop?(number)

      Object.const_get(train_types[type][:class_name]).new(number)
      print_nn "Train #{number} successfully added."
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
      retry
    end
  end

  def add_route(station_list)
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

  def show_stations(station_list, train_types)
    return print_nn 'Empty.' if station_list.size.zero?

    station_list.each do |station|
      puts "\nStation #{station}:"
      train_types.each_value do |type|
        trains = station.trains.select { |t| t.class.to_s == type[:class_name] }
        puts "  #{type[:title]} trains:"
        if trains.size.zero?
          puts '    none'
        else
          trains.each do |train|
            puts "    Number: #{train} Wagons: #{train.wagons.size}"
          end
        end
      end
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

  def add_wagon(train_list, wagon_types)
    return print_nn 'Error: No trains found.' if train_list.size.zero?

    train = train_list[ask('Choose train: ', train_list)]
    wagon_type = wagon_types[ask('Choose wagon type: ', wagon_types)]

    begin
      wagon = Object.const_get(wagon_type[:class_name]).new
      train.add_wagon(wagon)
      print_nn "#{wagon_type[:title]} successfully coupled to #{train}."
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
    end
  end

  def remove_wagon(train_list)
    return print_nn 'Error: No trains found.' if train_list.size.zero?

    train = train_list[ask('Choose train: ', train_list)]

    begin
      train.remove_wagon
      print_nn 'Wagon successfully decoupled.'
    rescue RuntimeError => e
      print_nn "Error: #{e.message}"
    end
  end

  def add_route_station(route_list, station_list)
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

  def remove_route_station(route_list)
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
end
