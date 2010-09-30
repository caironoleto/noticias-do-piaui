class ArticlesController < ApplicationController
  # GET /articles.:format
  def index
    @articles = Article.ready(Time.now).paginate(:per_page => 30, :page => params.fetch(:page, 1).to_i)
  end

  # GET /articles/:id.:format
  def show
    @article = Article.find_by_slug(params[:slug])
    @title = @article.title
  end
  
  # GET /sitemap.xml
  def sitemap
    @articles = Article.all(:order => "published_at desc", :conditions => "text <> ''", :limit => 50000)
  end
end
