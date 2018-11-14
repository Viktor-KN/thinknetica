class CargoTrain < Train
  @instances = 0
  @trains = []

  def add_wagon(wagon)
    super(wagon) if wagon.is_a?(CargoWagon)
  end
end
