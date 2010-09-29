require 'spec_helper'

describe ArticlesController do
  def mock_article(stubs = {})
    @mock_article ||= mock_model(Article, stubs)
  end

  context 'GET index' do
    describe 'responding to GET index' do
      it 'should expose articles as @articles' do
        articles = [mock_article]
        Article.should_receive(:ready).and_return(articles)
        articles.should_receive(:paginate).with(:per_page => 30, :page => 1).and_return(articles)
        get :index
        assigns[:articles].should eql articles
      end

      it 'should render index template' do
        Article.stub!(:paginate).and_return([mock_article])
        get :index
        response.should render_template(:index)
      end
    end
  end

  context 'GET show' do
    describe 'responding to GET show' do
      it 'should expose article as @article' do
        Article.should_receive(:find_by_slug).with('value-for-slug').and_return(mock_article(:title => "Whatever"))
        get :show, :slug => "value-for-slug"
        assigns[:article].should eql mock_article
      end

      it 'should expose article title as @title' do
        Article.should_receive(:find_by_slug).with('value-for-slug').and_return(mock_article)
        mock_article.should_receive(:title).and_return("This is my title")
        get :show, :slug => "value-for-slug"
        assigns[:title].should eql "This is my title"
      end

      it 'should render show template' do
        Article.stub!(:find).and_return(mock_article(:title => "Whatever"))
        get :show, :slug => "value-for-slug"
        response.should render_template(:show)
      end
    end
  end
end
