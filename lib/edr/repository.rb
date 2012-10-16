require_relative 'registry'

module Edr
  module Repository
    def persist model
      persisted_data = data(model).save(:raise_on_failure => true)
      return nil unless persisted_data

      model.id = persisted_data.id
      model
    end

    def delete model
      data(model).destroy
    end

    def delete_by_id id
      data_class[id].destroy
    end

    def find id
      model_class.new(data_class[id])
    end

    def all
      data_class.all.map do |data|
        model_class.new(data)
      end
    end

    def count
      data_class.count
    end

    def data model
      model._data
    end

    def set_model_class model_class, options
      if options[:root]
        singleton_class.send :define_method, :data_class do
          Registry.data_class_for model_class
        end

        singleton_class.send :define_method, :model_class do
          model_class.constantize
        end
      end
    end

    private

    def where attrs
      data_class.where(attrs).map do |data|
        model_class.new(data)
      end
    end
  end
end
