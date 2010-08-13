class Article < ActiveRecord::Base
  belongs_to :domain
  after_save :add_process_in_delayed_job
  
  def add_process_in_delayed_job
    process
  end
  
  handle_asynchronously :add_process_in_delayed_job
end
