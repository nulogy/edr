module Edr
  module AR
    module DataValidator
      def self.validate model
        data = model._data
        if data.valid?
          []
        else
          data.errors.full_messages
        end
      end
    end
  end
end
