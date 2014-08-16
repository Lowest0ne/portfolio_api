require 'rails_helper'

RSpec.describe Project, :type => :model do

  it { should validate_presence_of( :name ) }
  it { should validate_presence_of( :description ) }

  it 'validates unquiness of name' do
    p = Project.create( name: 'project', description: 'desc' )

    invalid = Project.new( p.attributes )
    expect( invalid ).to_not be_valid
    expect( invalid.errors[:name] ).to include( 'has already been taken' )
  end
end
