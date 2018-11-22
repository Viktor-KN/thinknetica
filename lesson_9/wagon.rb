# rubocop:disable Style/Documentation
class Wagon
  include Instances
  include Manufacturer
  include Validation

  attr_reader :number

  validate :number, :type, String
  validate :number, :format, /^[\d]{4}-[\d]{4}$/ # 1234-5678

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

  def validate!
    super
    raise 'Wagon with that number already exist.' if self.class.find(number)
  end
end
# rubocop:enable Style/Documentation
