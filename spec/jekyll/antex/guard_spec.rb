# frozen_string_literal: true

require 'jekyll/antex/guard'

describe Jekyll::Antex::Guard do
  let(:guards) do
    {
      valid: {
        priority: 10,
        regexp: /(?<code>)/x
      }
    }
  end

  it 'can be used as a matcher for Stasher' do
    expect(described_class.new(guards[:valid]))
      .to respond_to(:priority, :regexp)
  end
end
