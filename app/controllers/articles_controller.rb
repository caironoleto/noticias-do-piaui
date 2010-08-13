class ArticlesController < ApplicationController
  # GET /articles.:format
  def index
    @articles = Article.all
  end

  # GET /articles/:id.:format
  def show
    @article = Article.find(params[:id])
  end
end
