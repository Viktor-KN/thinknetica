class CargoTrain < Train
  def add_wagon(wagon)
    super(wagon) if wagon.class == CargoWagon
  end
end
