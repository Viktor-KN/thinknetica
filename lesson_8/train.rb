class Train
  include Manufacturer
  include Instances
  include Valid

  attr_reader :number, :wagons, :speed, :route, :station

  def self.find(number)
    instances.find { |instance| instance.number == number }
  end

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    validate!
    register_instance
  end

  def speed=(speed)
    raise 'Speed must be positive or zero.' if speed < 0

    @speed = speed
  end

  def stop
    self.speed = 0
  end

  def allowed_wagons
    %i[PassengerWagon CargoWagon]
  end

  def allowed_wagon?(wagon_type)
    allowed_wagons.include?(wagon_type)
  end

  def wagons?
    wagons.size.zero?
  end

  def station_assigned?
    !!station
  end

  def route_assigned?
    !!route
  end

  def wagon_count
    wagons.size
  end

  def add_wagon(wagon)
    type = wagon.class
    unless allowed_wagon?(type.to_s.to_sym)
      raise "Can't couple #{type} to #{self.class}."
    end

    raise "Can't couple #{type}, train is moving." unless speed.zero?

    wagons << wagon
  end

  def remove_wagon
    raise 'No more wagons left.' unless wagons?

    wagon = wagons.last
    raise "Can't decouple #{wagon.class}, train is moving." unless speed.zero?

    wagons.delete(wagon)
  end

  def each_wagon
    raise 'No block given.' unless block_given?

    wagons.each { |wagon| yield(wagon) }
  end

  def route=(route)
    station.remove_train(self) if station_assigned?
    @route = route
    self.station = route.stations.first
    station.add_train(self)
  end

  def move_to_next
    validate_move

    next_station = self.next_station
    raise "Can't move, already on last station." if next_station == station

    move(next_station)
  end

  def move_to_previous
    validate_move

    previous_station = self.previous_station
    raise "Can't move, already on first station." if previous_station == station

    move(previous_station)
  end

  def next_station
    validate_move

    current_index = route.stations.index(station)
    last_index = route.stations.size - 1
    next_index = current_index == last_index ? last_index : current_index + 1
    route.stations[next_index]
  end

  def previous_station
    validate_move

    current_index = route.stations.index(station)
    prev_index = current_index.zero? ? 0 : current_index - 1
    route.stations[prev_index]
  end

  def to_s
    number
  end

  protected

  attr_writer :station

  def number_format
    /^[a-z\d]{3}-?[a-z\d]{2}$/i # ABC-DE, ABCDE, 123-45, 12345, 1A2-B3...
  end

  def number_valid?
    number_format =~ number
  end

  def move(target_station)
    station.remove_train(self)
    target_station.add_train(self)
    self.station = target_station
  end

  def validate!
    raise 'Wrong number format.' unless number_valid?

    raise 'Train with that number already exist.' if self.class.find(number)
  end

  def validate_move
    raise 'No route assigned.' unless route_assigned?

    raise 'Not on any station.' unless station_assigned?
  end

end
