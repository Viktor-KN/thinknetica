class CargoTrain < Train
  def add_wagon(wagon)
    super(wagon) if wagon.is_a?(CargoWagon)
  end
end
