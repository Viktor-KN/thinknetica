# rubocop:disable Style/Documentation
module Instances
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances
      @instances ||= []
    end

    private

    def add_instance(instance)
      instances << instance
    end
  end

  module InstanceMethods
    private

    def register_instance
      self.class.send :add_instance, self
    end
  end
end
# rubocop:enable Style/Documentation
