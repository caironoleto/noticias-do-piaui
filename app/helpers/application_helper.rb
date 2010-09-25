# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TweetButton
  TweetButton.default_tweet_button_options = {:via => "noticiasdopiaui", :count => "horizontal"}
end
