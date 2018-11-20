# rubocop:disable Style/Documentation
class Wagon
  include Instances
  include Manufacturer
  include Valid

  attr_reader :number

  def self.find(number)
    instances.find { |instance| instance.number == number }
  end

  def initialize(number)
    @number = number
    validate!
    register_instance
  end

  def to_s
    number
  end

  protected

  def number_format
    /^[\d]{4}-[\d]{4}$/ # 1234-5678
  end

  def number_valid?
    number_format =~ number
  end

  def validate!
    raise 'Wrong number format.' unless number_valid?

    raise 'Wagon with that number already exist.' if self.class.find(number)
  end
end
# rubocop:enable Style/Documentation
