require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::ArrayOf do
  subject { described_class.new(double) }

  specify 'its default value is []' do
    expect(subject.default_value).to eq([])
  end
end
