require 'spec_helper'

describe Domain do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :url => "value for url",
      :feed_url => "file://#{Rails.root}/spec/fixtures/180_rss.rss"
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

  it "should create only the new article" do
    subject.process
    subject.update_attributes(:feed_url => "file://#{Rails.root}/spec/fixtures/180_rss_11.rss")
    lambda {
      subject.process
    }.should change(Article, :count).by(1)
  end

  it "should don't change articles" do
    subject.process
    lambda {
      subject.process
    }.should_not change(Article, :count)
  end
end
