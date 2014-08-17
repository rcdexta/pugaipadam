require 'test_helper'

describe Persona do

  let(:persona) { build(:persona) }

  describe '#present' do
    it 'should be false if none of the persona present' do
      persona.wont_be :present?
    end

    it 'should be true if any of the persona present' do
      persona.twitter = '@rcdexta'
      persona.must_be :present?
    end
  end

end
