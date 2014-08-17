FactoryGirl.define do

  factory :project do
    project_id 1
    account_name 'GruppoPAM'
    project_name 'Merchandise Platform'
  end

  factory :persona do
  end

  factory :consultant do
    employee_id 1231
    name 'James Bond'
    nickname 'Bond'
    mobile 101010101
    email 'jb@secretservice.com'
    role 'spy'
    grade 'ladykiller'
    experience '16.0'
    tw_experience '0.0'
    active true
  end

end
