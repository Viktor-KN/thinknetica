class Train
  private

  attr_writer :wagons, :station

  public

  attr_reader :number, :type, :wagons, :route, :station
  attr_accessor :speed

  def initialize(number, type, wagons)
    @number = number
    @type = type
    @wagons = wagons >= 0 ? wagons : 0
    @speed = 0
    @route = nil
    @station = nil
  end

  def stop
    self.speed = 0
  end

  def add_wagon
    self.wagons += 1 if speed.zero?
  end

  def remove_wagon
    self.wagons -= 1 if speed.zero? && wagons > 0
  end

  def route=(route)
    station.remove_train(self) if station
    @route = route
    self.station = route.stations.first
    station.add_train(self)
  end

  def move(direction)
    return unless station && route

    case direction
    when :next
      next_station = self.next_station
      return if next_station == station

      station.remove_train(self)
      next_station.add_train(self)
      self.station = next_station
    when :previous
      previous_station = self.previous_station
      return if previous_station == station

      station.remove_train(self)
      previous_station.add_train(self)
      self.station = previous_station
    end
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
end
