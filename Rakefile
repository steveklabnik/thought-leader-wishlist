$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default do
  Rake::Task['generate_wishlist'].invoke("production")
  Rake::Task['generate_thoughts'].invoke("production")
end