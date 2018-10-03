class TestController < ApplicationController
  def index
    render :json => {:message => "Hello world !"}.to_json
  end
end
