class ArticlesController < ApplicationController
  # GET /articles.:format
  def index
    @articles = Article.paginate(:per_page => 30, :page => params.fetch(:page, 1).to_i)
  end

  # GET /articles/:id.:format
  def show
    @article = Article.find_by_slug(params[:slug])
  end
end
