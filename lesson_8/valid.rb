# rubocop:disable Style/Documentation
module Valid
  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end
end
# rubocop:enable Style/Documentation
