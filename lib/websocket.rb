#!/usr/bin/env ruby
ENV["RAILS_ENV"] = "development"
ENV["DOMAIN"] = "localhost"
if ARGV.index('--')
  ENV["RAILS_ENV"] = ARGV[ARGV.index('--') + 1]
  if ENV["RAILS_ENV"] == "production"
    ENV["DOMAIN"] = "http://news.caironoleto.com"
  end
end

require "rubygems"
require "lib/websocket/lib/web_socket"
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require "simple-daemon"

class Processor < SimpleDaemon::Base
  SimpleDaemon::WORKING_DIRECTORY = "log" 

  def self.start
    server = WebSocketServer.new(:accepted_domains => ["*"], :port => 3001)
    server.run() do |ws|
      ws.handshake()
      loop do
        article = Article.ready.first.to_json(:include => {:domain => {:only => [:url, :title, :slug]}})
        puts article
        ws.send(article)
        sleep(5)
      end
    end
  end

  def self.stop
    puts "Stopping processor  " 
  end
end

Processor.daemonize