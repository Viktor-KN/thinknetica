# rubocop:disable Style/Documentation
class PassengerWagon < Wagon
  attr_reader :seats, :busy_seats

  validate :seats, :type, Integer
  validate :seats, :min_integer_value, 1

  def initialize(number, seats)
    @seats = seats
    @busy_seats = 0
    super(number)
    self.class.superclass.send :add_instance, self
  end

  def take_seat
    raise "Can't take seat, all seats are busy." if busy_seats == seats

    self.busy_seats += 1
  end

  def free_seats
    seats - busy_seats
  end

  protected

  attr_writer :busy_seats
end
# rubocop:enable Style/Documentation
