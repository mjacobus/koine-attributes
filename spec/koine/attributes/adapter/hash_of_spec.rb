require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::ArrayOf do
  subject { described_class.new(double) }

  it_behaves_like_an_adapter
end
