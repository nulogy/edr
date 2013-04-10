require 'forwardable'
require_relative 'registry'

module Edr
  module Model
    def self.included(base)
      base.extend ClassMethods
      base.extend ::Forwardable
    end

    attr_writer :_data

    def mass_assign(attributes)
      attributes.each do |k, v|
        self.send "#{k}=", v
      end
    end

    def as_json(options={})
      _data.as_json(options)
    end

    def _data
      @_data ||= self.class._new_instance
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
        model_class.build association
      end
    end


    module ClassMethods
      def build(data = _new_instance)
        instance = new

        if data.kind_of?(Hash)
          instance._data =  _new_instance(data)
        else
          instance._data = data
        end

        return instance
      end

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

      def _new_instance hash = {}
        Registry.data_class_for(self).new hash
      end
    end
  end
end
