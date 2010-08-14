ActionController::Routing::Routes.draw do |map|
  map.connect "noticias/:page", :controller => :articles, :action => :index, :page => /\d+/
  map.article "noticias/:slug", :controller => :articles, :action => :show
  map.connect "noticias/", :controller => :articles, :action => :index
  map.root :controller => :articles, :action => :index
end
