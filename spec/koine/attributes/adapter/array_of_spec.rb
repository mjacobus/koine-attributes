require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::ArrayOf do
  subject { described_class.new(double) }

  it_behaves_like_an_adapter

  specify 'its default value is []' do
    expect(subject.default_value).to eq([])
  end
end
