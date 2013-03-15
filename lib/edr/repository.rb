require_relative 'registry'

module Edr
  module Repository
    def delete model
      data(model).destroy
    end

    def delete_by_id id
      data_class.find(id).destroy
    end

    def find id
      wrap(data_class.find(id))
    end

    def all
      data_class.all.map do |data|
        wrap(data)
      end
    end

    def persist model
      data_object = data(model)
      data_object.save!
      
      model.id = data_object.id
      model.send(:repository=, self)
      
      model
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
        Registry.data_class_for(model_class)
      end

      singleton_class.send :define_method, :model_class do
        model_class
      end
    end

    private

    def where attrs
      data_class.where(attrs).map do |data|
        wrap(data)
      end
    end
  end
end
