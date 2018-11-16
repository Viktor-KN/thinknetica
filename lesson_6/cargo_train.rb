class CargoTrain < Train
  def initialize(number)
    super(number)
    self.class.superclass.send :add_instance, self
  end

  def allowed_wagons
    %i[CargoWagon]
  end
end
