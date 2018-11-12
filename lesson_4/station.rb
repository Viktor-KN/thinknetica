class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
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
