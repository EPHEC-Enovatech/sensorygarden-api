class DatasController < ApplicationController
  def index
    render :json => DataRecord.all
  end

  def create 
    
  end
end
