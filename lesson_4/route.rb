class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def remove_station(station)
    stations.delete(station) unless station == stations.first &&
                                    station == stations.last
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
end
