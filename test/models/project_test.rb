require 'test_helper'

describe Project do

  let(:project) { build(:project, account_name: 'acc', project_name: 'pro') }

  describe '#name' do
    it 'must be account and project concatenated' do
      project.name.must_equal 'acc - pro'
    end
  end

end
