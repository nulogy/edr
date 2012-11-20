require 'ostruct'

module Edr
  class Registry
    def self.define(&block)
      @@instance = self.new(&block)
    end

    def self.data_class_for(model_class)
      @@instance.data_class_for(model_class)
    end

    def self.model_class_for(data_class)
      @@instance.model_class_for(data_class)
    end

    def initialize(&block)
      @data_to_model_map = {}
      @model_to_data_map = {}
      self.instance_eval &block
    end

    # the mapping is done by the class names, to avoid
    # class-reloading issues in Rails dev mode
    def map model_class, data_class
      @model_to_data_map[model_class.to_s] = data_class.to_s
      @data_to_model_map[data_class.to_s] = model_class.to_s
    end

    def data_class_for model_class
      data_class = @model_to_data_map[model_class.to_s]
      return OpenStruct unless data_class

      data_class.constantize
    end

    def model_class_for data_class
      model_class = @data_to_model_map[data_class.to_s]
      raise "No model class for #{data_class.to_s}" unless model_class

      model_class.constantize
    end

    private

    def model_to_data_map
      @model_to_data_map
    end

    def data_to_model_map
      @data_to_model_map
    end
  end
end
