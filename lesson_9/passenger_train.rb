# rubocop:disable Style/Documentation
class PassengerTrain < Train
  def initialize(number)
    super(number)
    self.class.superclass.send :add_instance, self
  end

  def allowed_wagons
    %i[PassengerWagon]
  end
end
# rubocop:enable Style/Documentation
