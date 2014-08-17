require 'rails_helper'

RSpec.describe Project, :type => :model do

  it { should validate_presence_of( :name ) }
  it { should validate_presence_of( :description ) }

  it 'validates unquiness of name' do
    p = FactoryGirl.create( :project )

    invalid = Project.new( p.attributes )
    expect( invalid ).to_not be_valid
    expect( invalid.errors[:name] ).to include( 'has already been taken' )
  end

  it 'has a valid factory' do
    expect( FactoryGirl.create( :project ) ).to be_valid
    expect( FactoryGirl.build( :project ) ).to be_valid
  end

end
