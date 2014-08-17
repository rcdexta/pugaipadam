require 'test_helper'

describe Consultant do

  let(:consultant) { build(:consultant) }

  describe 'validations' do
    it 'name is mandatory' do
      consultant.name = nil
      consultant.wont_be :valid?
      consultant.errors.count.must_equal 1
    end

    it 'password and confirmation should match' do
      consultant.password = 'abcd'
      consultant.password_confirmation = 'abcde'
      consultant.wont_be :valid?
      consultant.errors.count.must_equal 1
    end
  end

end
