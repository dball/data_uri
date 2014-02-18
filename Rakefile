require 'rake/testtask'
Rake::TestTask.new
task :default => :test

desc "Build a gem file"
task :build do
  system "gem build data_uri.gemspec"
end

