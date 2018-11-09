class Station
  private

  attr_writer :trains

  public

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

  def trains(type = :any)
    if type == :any
      @trains
    else
      @trains.select { |train| train.type == type }
    end
  end
end
