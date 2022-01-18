# frozen_string_literal: true

require 'rake/testtask'
Rake::TestTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: %i[test rubocop]

desc 'Build a gem file'
task :build do
  system 'gem build data_uri.gemspec'
end
