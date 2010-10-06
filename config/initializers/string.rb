class String
  def remove_www
    self.gsub("www.", "")
  end

  def remove_www!
    self.gsub!("www.", "")
  end
end