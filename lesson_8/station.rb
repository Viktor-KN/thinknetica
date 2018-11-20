# rubocop:disable Style/Documentation
class Station
  include Instances
  include Valid

  attr_reader :name

  def self.find(name)
    instances.find { |instance| instance.name.casecmp(name).zero? }
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
  end

  def train_count
    trains.size
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

  def each_train
    raise 'No block given.' unless block_given?

    trains.each { |train| yield(train) }
  end

  def to_s
    name
  end

  protected

  def name_min_length
    2
  end

  def validate!
    raise 'Name must be at least 2 chars long.' if name.length < name_min_length

    raise 'Station with that name already exist.' if self.class.find(name)
  end
end
# rubocop:enable Style/Documentation
