require 'spec_helper'

describe Domain do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :url => "value for url",
      :feed_url => "file://#{Rails.root}/spec/fixtures/180_rss.rss",
      :last_news_url => "#{Rails.root}/spec/fixtures/180_last_news.html",
      :last_news_search_field => ".lista-noticias .item h3 a"
    }
  end
  
  subject do
    Domain.create!(@valid_attributes)
  end
  
  it "should create slug after save" do
    subject.save
    subject.slug.should eql "value-for-title"
  end

  it "should create new article from feed" do
    lambda {
      subject.process
    }.should change(Article, :count).by(10)
  end

  it "should create new article from url" do
    subject.update_attributes(:feed_url => "whatever.xml")
    lambda {
      subject.process
    }.should change(Article, :count).by(10)
  end

  it "should create only the new article" do
    subject.process
    subject.update_attributes(:feed_url => "file://#{Rails.root}/spec/fixtures/180_rss_11.rss")
    lambda {
      subject.process
    }.should change(Article, :count).by(1)

    subject.update_attributes(:feed_url => "file://whatever.rss")
    subject.process
    subject.update_attributes(:last_news_url => "#{Rails.root}/spec/fixtures/180_last_news_11.html")
    lambda {
      subject.process
    }.should change(Article, :count).by(1)
  end

  it "should don't change articles" do
    subject.process
    lambda {
      subject.process
    }.should_not change(Article, :count)

    subject.update_attributes(:feed_url => "file://whatever.rss")
    subject.process
    lambda {
      subject.process
    }.should_not change(Article, :count)
  end
end
