class Api::V1::ProjectsController < ApplicationController

  before_action :authenticate_api_key, only: [:create, :update, :destroy]
  before_action :find_project, only: [:show, :update, :destroy]

  def show
    render json: @project, root: false
  end

  def index
    projects = Project.select( :id, :name, :description )
    render json: projects, root: false
  end


  def create
    @project = Project.new( project_params )
    assignment_directions{ @project.save }
  end

  def update
    assignment_directions{ @project.update( project_params ) }
  end

  def destroy
    @project.destroy
    redirect_to api_v1_projects_path
  end

  protected

  def project_params
    params.require( :project ).permit( :name, :description )
  end

  def find_project
    @project = Project.find( params[:id] )
  end

  def assignment_directions
    yield ? redirect_to_project : render_errors
  end

  def redirect_to_project
    redirect_to api_v1_project_path( @project )
  end

  def render_errors
    render json: { errors: @project.errors }, status: :unprocessable_entity
  end


end
