class Train
  include Manufacturer
  include Instances
  include Valid

  # Вернул старый метод поиска, потому что теперь учет инстансов класса
  # унифицирован в модуле Instances.
  def self.find(number)
    instances.find { |instance| instance.number == number }
  end

  attr_reader :number, :wagons, :speed, :route, :station

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

  def add_wagon(wagon)
    type = wagon.class
    unless allowed_wagon?(type.to_s.to_sym)
      raise "Can't couple #{type} to #{self.class}."
    end

    raise "Can't couple #{type}, train is moving." unless speed.zero?

    wagons << wagon
  end

  def remove_wagon
    raise 'No more wagons left.' if wagons.size.zero?

    wagon = wagons.last
    raise "Can't decouple #{wagon.class}, train is moving." unless speed.zero?

    wagons.delete(wagon)
  end

  def each_wagon
    raise 'No block given.' unless block_given?

    wagons.each { |wagon| yield(wagon) }
  end

  def route=(route)
    station.remove_train(self) if station
    @route = route
    self.station = route.stations.first
    station.add_train(self)
  end

  def move_to_next
    raise "Can't move, no route assigned." unless route

    raise "Can't move, not on any station." unless station

    next_station = self.next_station
    raise "Can't move, already on last station." if next_station == station

    station.remove_train(self)
    next_station.add_train(self)
    self.station = next_station
  end

  def move_to_previous
    raise "Can't move, no route assigned." unless route

    raise "Can't move, not on any station." unless station

    previous_station = self.previous_station
    raise "Can't move, already on first station." if previous_station == station

    station.remove_train(self)
    previous_station.add_train(self)
    self.station = previous_station
  end

  def next_station
    raise 'No route assigned.' unless route

    raise 'Not on any station.' unless station

    current_index = route.stations.index(station)
    last_index = route.stations.size - 1
    next_index = current_index == last_index ? last_index : current_index + 1
    route.stations[next_index]
  end

  def previous_station
    raise 'No route assigned.' unless route

    raise 'Not on any station.' unless station

    current_index = route.stations.index(station)
    prev_index = current_index.zero? ? 0 : current_index - 1
    route.stations[prev_index]
  end

  def to_s
    number
  end

  protected

  def validate!
    raise 'Wrong number format.' if /^[a-z\d]{3}-?[a-z\d]{2}$/i !~ number

    raise 'Train with that number already exist.' if self.class.find(number)
  end

  attr_writer :station
end
