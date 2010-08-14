require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do
  it "should have a route" do
    {:get => "/noticias"}.should route_to(:controller => "articles", :action => "index")
    {:get => "/noticias/2"}.should route_to(:controller => "articles", :action => "index", :page => "2")
    {:get => "/noticias/value-of-slug"}.should route_to(:controller => "articles", :action => "show", :slug => "value-of-slug")
  end
end