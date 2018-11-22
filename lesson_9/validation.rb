# rubocop:disable Style/Documentation
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
    base.send :init_validation
  end

  module ClassMethods
    def validate(name, type, param = nil)
      validate_self(name, type, param)
      validation_table[type][name] = param
    end

    protected

    attr_accessor :validation_types, :validation_table

    # rubocop:disable Metrics/MethodLength
    def init_validation
      self.validation_types = {
        presence: { param_required?: false, param_type: NilClass },
        format: { param_required?: true, param_type: Regexp },
        type: { param_required?: true, param_type: Class },
        min_string_length: { param_required?: true, param_type: Integer },
        max_string_length: { param_required?: true, param_type: Integer },
        min_integer_value: { param_required?: true, param_type: Integer },
        max_integer_value: { param_required?: true, param_type: Integer },
        min_float_value: { param_required?: true, param_type: Float },
        max_float_value: { param_required?: true, param_type: Float }
      }

      self.validation_table = {}
      validation_types.each_key { |key| validation_table[key] = {} }
    end
    # rubocop:enable Metrics/MethodLength

    def inherited(child)
      child.send :init_validation
      child_validation_table = child.instance_variable_get(:@validation_table)
      validation_table.each { |key, value| child_validation_table[key] = value.dup }
      child.instance_variable_set(:@validation_table, child_validation_table)
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def validate_self(name, type, param)
      param_is_required = validation_types[type][:param_required?]
      param_type = validation_types[type][:param_type]

      raise ArgumentError, "variable '#{name}' should be a 'Symbol'" unless name.is_a?(Symbol)

      raise ArgumentError, "variable '#{type}' should be a 'Symbol'" unless type.is_a?(Symbol)

      raise ArgumentError, "undefined validation type '#{type}'" unless validation_types.key?(type)

      raise ArgumentError, "argument is required for validation type ''#{type}''" \
                           if param.nil? && param_is_required

      raise ArgumentError, "'#{type}' validation type require '#{param_type}' type param" \
                           if param_is_required && !param.is_a?(param_type)
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  end

  module InstanceMethods
    def validate!
      validation_table.each { |type, attributes| validate_each(type, attributes) }
    end

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    protected

    def validation_table
      self.class.instance_variable_get(:@validation_table)
    end

    def get_var(name)
      send name
    end

    def validate_each(type, attributes)
      attributes.each do |name, param|
        name_var = get_var(name)
        send "validate_#{type}", name, name_var, param
      end
    end

    def validate_presence(name, name_var, _param)
      raise "variable '#{name}' can't be nil" if name_var.nil?

      raise "variable '#{name}' can't be empty" if name_var.is_a?(String) && name_var.empty?
    end

    def validate_format(name, name_var, param)
      raise "'#{name}' variable format incorrect" unless param =~ name_var
    end

    def validate_type(name, name_var, param)
      raise "'#{name}' variable type incorrect, expecting '#{param}'" unless name_var.is_a?(param)
    end

    def validate_min_string_length(name, name_var, param)
      raise "'#{name}' variable must be greater or equal to '#{param}'" if name_var.length < param
    end

    def validate_max_string_length(name, name_var, param)
      raise "'#{name}' variable must be less or equal to '#{param}'" if name_var.length > param
    end

    def validate_min_integer_value(name, name_var, param)
      raise "'#{name}' variable must be greater or equal to '#{param}'" if name_var < param
    end

    def validate_max_integer_value(name, name_var, param)
      raise "'#{name}' variable must be less or equal to '#{param}'" if name_var > param
    end

    def validate_min_float_value(name, name_var, param)
      raise "'#{name}' variable must be greater or equal to '#{param}'" if name_var < param
    end

    def validate_max_float_value(name, name_var, param)
      raise "'#{name}' variable must be less or equal to '#{param}'" if name_var > param
    end
  end
end
# rubocop:enable Style/Documentation
