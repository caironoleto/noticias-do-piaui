require 'spec_helper'

describe Article do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :text => "value for text",
      :origin_url => "#{Rails.root}/spec/fixtures/180_page.html",
      :published_at => Time.now
    }
  end
  
  subject do
    Article.new(@valid_attributes)
  end
  
  before(:each) do
    valid_attributes = {
      :title => "value for title",
      :url => "value for url",
      :feed_url => "#{File.read("spec/fixtures/180_rss.rss")}",
      :nokogiri_search_field => "texto_materia"
    }

    domain = Domain.create!(valid_attributes)
    subject.update_attributes(:domain => domain)
  end

  it "should add in DJ after save" do
    lambda {
      subject.save 
    }.should change(Delayed::Backend::ActiveRecord::Job, :count).by(1)
  end
  
  it "should get new text" do
    
  end
end
