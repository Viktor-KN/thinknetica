# rubocop:disable Style/Documentation
class Route
  include Instances
  include Valid

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
    # rubocop:disable Style/MultipleComparison
    raise "Can't remove first or last station." if station == stations.first ||
                                                   station == stations.last

    # rubocop:enable Style/MultipleComparison
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

  protected

  def validate!
    raise 'First and last stations must vary.' \
          if stations.first == stations.last
  end
end
# rubocop:enable Style/Documentation
