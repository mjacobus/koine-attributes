require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Base do
  subject do
    Class.new(described_class) {}.new.tap do |k|
      k.with_attribute_name('time')
    end
  end

  let(:counter) do
    Class.new do
      def next
        @counter ||= 0
        @counter += 1
      end
    end.new
  end

  describe '#default_value' do
    it 'defaults to nil' do
      expect(subject.default_value).to be(nil)
    end

    it 'returns defined value when it was set' do
      object = subject.with_default_value('foo')

      expect(object.default_value).to eq('foo')
    end

    it 'returns result of block when default value is a block' do
      object = subject.with_default_value { counter.next }

      expect(object.default_value).to be(1)
      expect(object.default_value).to be(2)
    end
  end

  specify '#coerce raises NotImplementedError' do
    expect { subject.coerce('foo') }.to raise_error(NotImplementedError)
  end
end
