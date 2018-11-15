class Station
  include InstanceCounter

  attr_reader :name

  class << self
    private

    def stations
      @stations ||= []
    end

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
    if type
      @trains.select { |train| train.class == type }
    else
      @trains
    end
  end

  def to_s
    name
  end
end
