FactoryGirl.define do

  factory :project do
    sequence( :name ){ |n| "project_#{n}" }
    description 'project description'
  end


end
