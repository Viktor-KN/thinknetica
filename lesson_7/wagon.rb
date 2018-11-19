class Wagon
  include Instances
  include Manufacturer

  def self.find(number)
    instances.find { |instance| instance.number == number }
  end

  attr_reader :number

  def initialize(number)
    @number = number
    validate!
    register_instance
  end

  def to_s
    number
  end

  protected

  def validate!
    raise 'Wrong number format.' if /^[\d]{4}-[\d]{4}$/ !~ number

    raise 'Wagon with that number already exist.' if self.class.find(number)
  end
end
