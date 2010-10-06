require File.dirname(__FILE__) + '/acceptance_helper'

feature "Articles" do
  feature "index" do
    background(:each) do
      @domain = Domain.create!(:title => 'This is my domain')
      @first = Article.create!(:title => 'This is my first title', :text => "This is my text one", :published_at => Time.now - 3.hours, :domain => @domain)
      @second = Article.create!(:title => 'This is my second title', :text => "This is my text two", :published_at => Time.now - 4.hours, :domain => @domain)
    end
    scenario "should list all article when access root url" do
      visit "/"
      page.should have_link(@first.title)
      page.should have_link(@second.title)
    end

    scenario "should list all articles" do
      visit "/noticias"
      page.should have_link(@first.title)
      page.should have_link(@second.title)
    end
    
    scenario "should show text after click", :js => true do
      visit "/noticias"
      click(@first.title)
      page.should have_content(@first.text)
      page.should_not have_content(@second.text)
    end
  end
end