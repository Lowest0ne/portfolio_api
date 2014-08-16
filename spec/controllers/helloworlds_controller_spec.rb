describe Api::V1::HelloWorldsController, type: :controller do

  describe 'GET /hello' do

    before( :each ){ get :hello }


    it { expect( response.status ).to eql( 200 ) }

    it 'responds with content Hello World!' do
      expect( JSON.parse( response.body )['content'] ).to eql( 'Hello World!' )
    end


  end


end
