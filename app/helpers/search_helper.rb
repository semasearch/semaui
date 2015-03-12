module SearchHelper
  def replace_quotes (name)
    name.gsub! '"', '\x22'
    name.gsub! "'", '\x27'
    name
  end
end
