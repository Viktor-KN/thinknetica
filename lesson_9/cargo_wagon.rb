# rubocop:disable Style/Documentation
class CargoWagon < Wagon
  attr_reader :volume, :occupied_volume

  validate :volume, :type, Float
  validate :volume, :min_float_value, 1.0

  def initialize(number, volume)
    @volume = volume
    @occupied_volume = 0.0
    super(number)
    self.class.superclass.send :add_instance, self
  end

  def occupy_volume(volume)
    occupied_volume = self.occupied_volume + volume
    if occupied_volume > self.volume
      raise "Can't occupy that volume, there is no so much free volume."
    end

    self.occupied_volume = occupied_volume
  end

  def free_volume
    volume - occupied_volume
  end

  protected

  attr_writer :occupied_volume
end
# rubocop:enable Style/Documentation
