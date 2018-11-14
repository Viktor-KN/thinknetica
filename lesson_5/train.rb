class Train
  include Manufacturer
  include InstanceCounter

  @instances = 0
  @trains = []

  class << self
    private

    attr_reader :trains

    def add_train(train)
      trains << train
    end
  end

  def self.find(number)
    trains.find { |train| train.number == number }
  end

  attr_reader :number, :wagons, :speed, :route, :station

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    register_instance
    self.class.send :add_train, self
  end

  def speed=(speed)
    @speed = speed < 0 ? 0 : speed
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    wagons << wagon if speed.zero?
  end

  def remove_wagon
    wagons.delete(wagons.last) if !wagons.size.zero? && speed.zero?
  end

  def route=(route)
    station.remove_train(self) if station
    @route = route
    self.station = route.stations.first
    station.add_train(self)
  end

  def move_to_next
    return unless station && route

    next_station = self.next_station
    return if next_station == station

    station.remove_train(self)
    next_station.add_train(self)
    self.station = next_station
  end

  def move_to_previous
    return unless station && route

    previous_station = self.previous_station
    return if previous_station == station

    station.remove_train(self)
    previous_station.add_train(self)
    self.station = previous_station
  end

  def next_station
    return unless station && route

    current_index = route.stations.index(station)
    last_index = route.stations.size - 1
    next_index = current_index == last_index ? last_index : current_index + 1
    route.stations[next_index]
  end

  def previous_station
    return unless station && route

    current_index = route.stations.index(station)
    prev_index = current_index.zero? ? 0 : current_index - 1
    route.stations[prev_index]
  end

  def to_s
    number
  end

  private

  # station= должен использоваться только изнутри класса, т.к. при присвоении
  #   извне поломается вся логика определения следующей и предыдущей станции в
  #   маршруте.
  attr_writer :station
end
