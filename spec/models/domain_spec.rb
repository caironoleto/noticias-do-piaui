require 'spec_helper'

describe Domain do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :url => "value for url"
    }
  end

  it "should create a new instance given valid attributes" do
    Domain.create!(@valid_attributes)
  end
end
