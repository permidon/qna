class SearchesController < ApplicationController
  authorize_resource

  def show
    @query = params[:query]
    @result = Search.search(params[:source], @query)
  end
end