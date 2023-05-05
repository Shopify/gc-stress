# frozen_string_literal: true

require "bundler/setup"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

YARD::Rake::YardocTask.new

RuboCop::RakeTask.new

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: [:test, :rubocop]
