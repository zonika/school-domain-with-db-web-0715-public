require_relative '../config/environment'
DB[:conn] = SQLite3::Database.new ":memory:"

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :progress # :progress, :html, :textmate

  #you can do global before/after here like this:
  #config.before(:each) do
  #  #code
  #end
end
