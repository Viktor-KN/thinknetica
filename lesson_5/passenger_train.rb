class PassengerTrain < Train
  @instances = 0
  @trains = []

  def add_wagon(wagon)
    super(wagon) if wagon.is_a?(PassengerWagon)
  end
end
