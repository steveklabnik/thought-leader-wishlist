$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

task :default => :spec do
  puts "Generating wishlist..."
  Rake::Task['generate_wishlist'].invoke("production")
  puts "Generating thoughts..."
  Rake::Task['generate_thoughts'].invoke("production")
  puts "Done"
end