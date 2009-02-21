require 'cucumber/rake/task'
require 'rake'
require 'rake/clean'
require 'spec/rake/spectask'


task :default => [ "features", "spec:rcov" ]


Cucumber::Rake::Task.new do | t |
  t.rcov = true 
end


namespace :spec do 
  desc "Run specs with RCov" 
  Spec::Rake::SpecTask.new( 'rcov' ) do | t |
    t.spec_files = FileList[ 'spec/**/*_spec.rb' ]
    t.spec_opts = [ '--color', '--format', 'specdoc' ]
    t.rcov = true 
  end 
end 



