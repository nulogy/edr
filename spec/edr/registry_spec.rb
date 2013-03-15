require 'spec_helper'
require_relative '../../lib/edr/registry'

describe Edr::Registry do
  class HasAModelData < ActiveRecord::Base; end
  class HasAModel; end

  class DoesntHaveAModelData < ActiveRecord::Base; end

  context "defining domain model to active record mappings" do
    subject { Edr::Registry }

    before do
      subject.map_models_to_mappers
    end

    it "maps every AR::Base with a class name ending in 'Data' to a domain model class with the same name less 'Data'" do
      expect(subject.model_class_for(HasAModelData)).to eq(HasAModel)
    end

    it "does not map an AR::Base ending in 'Data' to a domain model if none exist with the same name less 'Data'" do
      expect(subject.model_class_for(DoesntHaveAModelData)).to be_nil
    end
  end
end
