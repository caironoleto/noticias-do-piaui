ActionController::Routing::Routes.draw do |map|
  map.connect "noticias/:page", :controller => :articles, :action => :index, :page => /\d+/
  map.article "noticias/:slug", :controller => :articles, :action => :show
  map.connect "noticias/", :controller => :articles, :action => :index
  map.connect  ":slug/:page", :controller => :domains, :action => :show, :page => /\d+/
  map.domain  ":slug", :controller => :domains, :action => :show
  map.root :controller => :articles, :action => :index
end