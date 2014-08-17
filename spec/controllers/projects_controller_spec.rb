require 'rails_helper'

describe Api::V1::ProjectsController, type: :controller do
  let( :api_key          ){ ENV[ 'API_KEY' ] }
  let( :project ) { FactoryGirl.build( :project ) }
  let( :invalid_attributes ){ { name: '', description: '' } }

  describe 'GET show' do

    before( :each ) do
      project.save
      get :show, id: project.id
    end

    it 'responds with the project' do

      expect( response.status ).to eql( 200 )

      body = JSON.parse( response.body )
      expect( body[ 'name' ] ).to eql( project.name )
      expect( body[ 'description' ] ).to eql( project.description )
    end

  end

  describe 'GET index' do

    before( :each ) do
      FactoryGirl.create_list( :project, 2 )
      get :index
    end

    it 'responds with all projects' do

      expect( response.status ).to eql( 200 )

      body = JSON.parse( response.body )

      Project.all.each do | project |
        attributes = JSON.parse( ProjectSerializer.new( project ).to_json )
        expect( body ).to include( attributes['project'] )
      end

    end
  end

  shared_examples_for 'an authenticated action' do

    it 'responds with invalid api key' do
      expect( response.status ).to be( 422 )
      expect( JSON.parse( response.body )['error'] ).to eql( 'invalid api key' )
    end

  end

  shared_examples_for 'a validating action' do

    it 'responsed with unprocessible entiry' do
      expect( response.status ).to eql( 422 )
    end

    it 'responds with errors' do
      errors = JSON.parse( response.body )[ 'errors' ]
      expect( errors['name'] ).to include( "can't be blank" )
      expect( errors['description'] ).to include( "can't be blank" )
    end

  end

  describe 'POST create' do

    context 'without the api key' do
      before( :each ){ post :create }
      it_behaves_like 'an authenticated action'

      it 'does not add a project to the database' do
        expect( Project.count ).to eql( 0 )
      end

    end

    context 'with invalid information' do


      before( :each ){ post :create, api_key: api_key, project: invalid_attributes }

      it_behaves_like 'a validating action'

    end

    context 'with valid information' do

      let( :api_key ){ ENV[ 'API_KEY' ] }
      let( :project ){ FactoryGirl.build( :project ) }

      it 'creates a project in the database' do

        previous_count = Project.count
        post :create, api_key: api_key, project: project.attributes
        expect( Project.count ).to eql( previous_count + 1 )

        expect( response.status ).to eql( 302 )
        expect( response ).to redirect_to( api_v1_project_path( Project.last ) )
      end

    end
  end

  describe 'PATCH update' do

    before( :each ){ project.save }

    context 'without the api key' do
      before( :each ){ patch :update, id: project.id }
      it_behaves_like 'an authenticated action'
    end

    context 'with invalid information' do
      before( :each ){ patch :update, api_key: api_key, id: project.id, project: invalid_attributes }
      it_behaves_like 'a validating action'

      it 'does not update the project' do
        before = project
        project.reload
        expect( before.attributes ).to eql( project.attributes )
      end
    end

    context 'with valid information' do

      it 'updates the project' do

        valid_attributes = { name: 'new name', description: 'new description' }
        patch :update, api_key: api_key, id: project.id, project: valid_attributes
        project.reload
        expect( project.name ).to eql( valid_attributes[:name] )
        expect( project.description ).to eql( valid_attributes[:description] )

      end

    end
  end

  describe 'DELETE destroy' do

    before( :each ) do
      project.save
      delete :destroy, id: project.id
    end

    it_behaves_like 'an authenticated action'

    it 'deletes the project with an api key given' do
      delete :destroy, id: project.id, api_key: api_key
      expect( Project.count ).to eql( 0 )

      expect( response.status ).to eql( 302 )
      expect( response ).to redirect_to( api_v1_projects_path )
    end

  end

end
