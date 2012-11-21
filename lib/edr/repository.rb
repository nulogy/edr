require_relative 'registry'

module Edr
  module Repository
    def delete model
      data_class.destroy data(model)
    end

    def delete_by_id id
      data_class.destroy(data_class.get!(id))
    end

    def find id
      wrap(data_class.get!(id))
    end

    def all
      data_class.find_all.map do |data|
        wrap(data)
      end
    end

    protected

    def wrap data
      model_class.new.tap do |m|
        m.send(:_data=, data)
        m.send(:repository=, self)
      end
    end

    def data model
      model._data
    end

    def set_model_class model_class
      singleton_class.send :define_method, :data_class do
        Registry.data_class_for(model_class).to_adapter
      end

      singleton_class.send :define_method, :model_class do
        model_class
      end
    end

    private

    def where attrs
      data_class.find_all(attrs).map do |data|
        wrap(data)
      end
    end
  end
end
