class Api::V1::HelloWorldsController < ApplicationController

  def hello

    hash = { content: 'Hello World!' }
    render json: hash

  end

end
