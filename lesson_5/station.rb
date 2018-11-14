class Station
  include InstanceCounter

  @instances = 0
  @stations = []

  attr_reader :name

  class << self
    private

    attr_reader :stations

    def add_station(station)
      stations << station
    end
  end

  def self.all
    stations
  end

  def initialize(name)
    @name = name
    @trains = []
    register_instance
    self.class.send :add_station, self
  end

  def add_train(train)
    trains << train
  end

  def remove_train(train)
    trains.delete(train)
  end

  def trains(type = nil)
    if type.nil?
      @trains
    else
      @trains.select { |train| train.class == type }
    end
  end

  def to_s
    name
  end
end
