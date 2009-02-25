require 'cucumber/rake/task'
require 'rake'
require 'rake/clean'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'


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


task :verify_rcov => [ "features" ]
RCov::VerifyTask.new do | t |
  t.threshold = 100
end


def egrep pattern
  Dir[ '**/*.rb' ].each do | each |
    count = 0
    open( each ) do | f |
      while line = f.gets
        count += 1
        if line =~ pattern
          puts "#{ each }:#{ count }:#{ line }"
        end
      end
    end
  end
end
 

desc "Look for TODO and FIXME tags in the code"
task :todo do
  egrep /(FIXME|TODO|TBD)/
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
