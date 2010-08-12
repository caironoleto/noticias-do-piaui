require 'spec_helper'

describe Article do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :text => "value for text",
      :origin_url => "value for origin_url",
      :published_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Article.create!(@valid_attributes)
  end
end
