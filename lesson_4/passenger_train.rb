class PassengerTrain < Train
  def add_wagon(wagon)
    super(wagon) if wagon.is_a?(PassengerWagon)
  end
end
