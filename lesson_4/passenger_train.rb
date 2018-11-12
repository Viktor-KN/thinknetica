class PassengerTrain < Train
  def add_wagon(wagon)
    super(wagon) if wagon.class == PassengerWagon
  end
end
