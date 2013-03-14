module Edr
  module AR
    module Repository
      include ::Edr::Repository

      def persist model
        data_object = data(model)
        data_object.save!

        model.id = data_object.id
        model.send(:repository=, self)

        model
      end
    end
  end
end
