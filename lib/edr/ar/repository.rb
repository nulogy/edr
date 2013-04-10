module Edr
  module AR
    module Repository
      include ::Edr::Repository

      def persist model
        data_object = data(model)
        data_object.save!

        model.id = data_object.id if model.respond_to?(:id)
        model.send(:repository=, self) if model.respond_to?(:repository, true)

        model
      end
    end
  end
end
