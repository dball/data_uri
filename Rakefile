desc "Build a gem file"
task :build do
  system "gem build data_uri.gemspec"
end

task :default => :test

task :test do
  system "ruby -Ilib test/test_*.rb"
end
