require_relative 'registry'

module Edr
  module Model
    def self.included(base)
      base.extend ClassMethods
      base.extend ::Forwardable
    end

    attr_accessor :_data

    def initialize _data = _new_instance
      if _data.kind_of?(Hash)
        @_data = _new_instance _data
      else
        @_data = _data
      end
    end

    def mass_assign(attributes)
      attributes.each do |k, v|
        self.send "#{k}=", v
      end
    end

    def as_json(options={})
      _data.as_json(options)
    end

    protected

    def repository
      raise "Transient objects don't have repositories" unless @repository
      @repository
    end

    def repository= repo
      @repository = repo
    end

    def association name
      _data.send(name)
    end

    def wrap association
      if association.respond_to? :first
        return [] if association.empty?
        association.map{|c| wrap c}
      else
        return nil if association.nil?
        model_class = Registry.model_class_for(association.class)
        model_class.new association
      end
    end

    def _new_instance hash = {}
      Registry.data_class_for(self.class).new hash
    end

    module ClassMethods
      def fields *field_names
        field_names.each do |field_name|
          def_delegators :_data, field_name
          def_delegators :_data, "#{field_name}="
        end
      end

      def wrap_associations *association_names
        association_names.each do |association_name|
          define_method association_name do
            wrap(association association_name)
          end
        end
      end
    end
  end
end
