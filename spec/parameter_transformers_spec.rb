require 'spec_helper'

describe ParameterTransformers::Proxy do

  class Tester

    def add_one_to_both(a, b)
      [a+1, b+1]
    end

    def self.add_one_to_both(a, b)
      [a+1, b+1]
    end
  end

  it 'takes given parameter transformers and applies whenever matched' do
    transformers = {
      [:add_one_to_both, :a] => ->(x) { x + 3 },
      [:add_one_to_both, :b] => ->(x) { x - 3 }
    }
    tc = ParameterTransformers::Proxy.new(Tester, transformers)
    r = tc.add_one_to_both(4, 5)
    expect(r.first).to eq(8)
    expect(r.last).to eq(3)

    t = ParameterTransformers::Proxy.new(Tester.new, transformers)
    r = t.add_one_to_both(4, 5)
    expect(r.first).to eq(8)
    expect(r.last).to eq(3)
  end
end
