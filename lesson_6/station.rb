class Station
  include Instances
  include Valid

  def self.find(name)
    instances.find { |instance| instance.name.casecmp(name).zero? }
  end

  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
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

  protected

  def validate!
    raise 'Name must be at least 2 chars long.' if name.length < 2

    raise 'Station with that name already exist.' if self.class.find(name)
  end
end
