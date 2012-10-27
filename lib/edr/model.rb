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

    def collection name
      _data.send(name)
    end

    def wrap collection
      return [] if collection.empty?
      model_class = Registry.model_class_for(collection.first.class)
      collection.map{|c| model_class.new c}
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

      def collections *collection_names
        collection_names.each do |collection_name|
          define_method collection_name do
            wrap(collection collection_name)
          end
        end
      end
    end
  end
end
