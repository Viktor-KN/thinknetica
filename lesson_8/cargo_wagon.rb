class CargoWagon < Wagon
  include Valid

  attr_reader :volume, :occupied_volume

  def initialize(number, volume)
    @volume = volume.to_f
    @occupied_volume = 0
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

  def validate!
    super
    raise 'Initial volume must be grater than zero.' unless volume > 0
  end
end
