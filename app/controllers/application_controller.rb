class ApplicationController < ActionController::API

  def authenticate_api_key

    unless params[:api_key] == ENV[ 'API_KEY' ]
      render json: { error: 'invalid api key' }, status: :unprocessable_entity
    end

  end

end
