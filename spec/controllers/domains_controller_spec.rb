require 'spec_helper'

describe DomainsController do
  def mock_domain(stubs = {})
    @mock_domain ||= mock_model(Domain, stubs)
  end

  def mock_article(stubs = {})
    @mock_article ||= mock_model(Article, stubs)
  end
  
  describe "GET show" do
    it "should render show template" do
      Domain.stub!(:find_by_slug).and_return(mock_domain(:articles => [mock_article], :title => ""))
      mock_domain.articles.stub!(:ready).and_return([mock_article])
      get :show, :slug => "180-graus"
    end
    
    it "should expose domain as @domain " do
      Domain.should_receive(:find_by_slug).with("meio-norte").and_return(mock_domain(:articles => [mock_article], :title => ""))
      mock_domain.articles.stub!(:ready).and_return([mock_article])
      get :show, :slug => "meio-norte"
      assigns[:domain].should eql mock_domain
    end
    
    it "should expose article as @articles" do
      articles = [mock_article]
      Domain.should_receive(:find_by_slug).with("cidade-verde").and_return(mock_domain(:articles => articles, :title => ""))
      mock_domain.articles.should_receive(:ready).with(Time.now).and_return(articles)
      mock_domain.articles.should_receive(:paginate).with(:per_page => 30, :page => 1).and_return(articles)
      get :show, :slug => "cidade-verde"
      assigns[:articles].should eql articles
    end
    
    it "should expose article as @articles with different page" do
      articles = [mock_article]
      Domain.should_receive(:find_by_slug).with("cidade-verde").and_return(mock_domain(:articles => articles, :title => ""))
      mock_domain.articles.should_receive(:ready).with(Time.now).and_return(articles)
      mock_domain.articles.should_receive(:paginate).with(:per_page => 30, :page => 2).and_return(articles)
      get :show, :slug => "cidade-verde", :page => "2"
      assigns[:articles].should eql [mock_article]
    end
    
    it "should expose domain title as @title" do
      Domain.should_receive(:find_by_slug).with("meio-norte").and_return(mock_domain(:articles => [mock_article]))
      mock_domain.articles.stub!(:ready).and_return([mock_article])
      mock_domain.should_receive(:title).and_return("This is my title")
      get :show, :slug => "meio-norte"
      assigns[:title].should eql "This is my title"
    end
  end
end
