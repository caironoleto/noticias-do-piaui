require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DomainsController do
  it "should have a route" do
    {:get => "/180-graus"}.should route_to(:controller => "domains", :action => "show", :slug => "180-graus")
    {:get => "/180-graus/2"}.should route_to(:controller => "domains", :action => "show", :page => "2", :slug => "180-graus")
  end
end