# rubocop:disable Style/Documentation
module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def attr_accessor_with_history(*names)
      names.each do |name|
        raise ArgumentError, "variable '#{name}' should be a Symbol" unless name.is_a?(Symbol)

        var_name = "@#{name}".to_sym
        var_name_history = "#{var_name}_history".to_sym
        name_history = "#{name}_history".to_sym

        define_method(name) { instance_variable_get(var_name) }

        define_method(name_history) { instance_variable_get(var_name_history) || [] }

        define_method("#{name}=") do |value|
          instance_variable_set(var_name, value)
          var_history = send name_history
          instance_variable_set(var_name_history, var_history << value)
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def strong_attr_accessor(name, type)
      strong_attr_validate(name, type)

      var_name = "@#{name}".to_sym
      var_name_type = "#{var_name}_type".to_sym

      define_method(name) { instance_variable_get(var_name) }
      instance_variable_set(var_name_type, type)
      strong_attr_writer(name, type)
    end

    def strong_attr_writer(name, type)
      strong_attr_validate(name, type)

      var_name = "@#{name}".to_sym
      var_name_type = "#{var_name}_type".to_sym
      instance_variable_set(var_name_type, type)

      define_method("#{name}=") do |value|
        var_type = self.class.instance_variable_get(var_name_type)
        raise ArgumentError, "method '#{name}' accepts only #{type} type" \
                             unless value.is_a?(var_type)

        instance_variable_set(var_name, value)
      end
    end

    protected

    def strong_attr_validate(name, type)
      raise ArgumentError, "variable '#{name}' should be a Symbol" unless name.is_a?(Symbol)
      raise ArgumentError, "type '#{type}' is not a 'Class' type" unless type.is_a?(Class)
    end
  end
end
# rubocop:enable Style/Documentation
