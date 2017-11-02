require 'rspec/core/rake_task'

require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/*_spec.rb')
end

RuboCop::RakeTask.new(:rubocop)

task :all do
  Rake::Task[:spec].execute
  Rake::Task[:rubocop].execute
end

task default: :all
