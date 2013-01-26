desc "Load Data"
task :load => :environment do
  Project.fetch!
end
