class Route
  include Instances

  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
    register_instance
  end

  def add_station(station)
    raise "Station #{station} already in route." if stations.include?(station)

    stations.insert(-2, station)
  end

  def remove_station(station)
    raise "Can't remove first or last station." if station == stations.first ||
                                                   station == stations.last

    stations.delete(station)
  end

  def to_s(highlight_station = nil)
    title = ''
    stations.each do |station|
      ast = station == highlight_station ? '*' : ''
      title += "#{ast}#{station.name}#{ast}" \
               "#{station == stations.last ? '' : ' - '}"
    end
    title
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  protected

  def validate!
    raise 'First and last stations must vary.' if @stations.first == @stations.last
  end
end
