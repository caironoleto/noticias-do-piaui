require 'spec_helper'

describe ArticlesController do
  def mock_article(stubs = {})
    @mock_article ||= mock_model(Article, stubs)
  end

  context 'GET index' do
    describe 'responding to GET index' do
      it 'should expose articles as @articles' do
        Article.should_receive(:paginate).with(:per_page => 30, :page => 1, :order => "published_at desc").and_return([mock_article])
        get :index
        assigns[:articles].should eql [mock_article]
      end

      it 'should render index template' do
        Article.stub!(:paginate).and_return([mock_article])
        get :index
        response.should render_template(:index)
      end
    end
  end

  context 'GET show' do
    describe 'responding go GET show' do
      it 'should expose article as @article' do
        Article.should_receive(:find_by_slug).with('value-for-slug').and_return(mock_article)
        get :show, :slug => "value-for-slug"
        assigns[:article].should eql mock_article
      end

      it 'should render show template' do
        Article.stub!(:find).and_return(mock_article)
        get :show, :slug => "value-for-slug"
        response.should render_template(:show)
      end
    end
  end
end
