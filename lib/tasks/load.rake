desc "Load Data"
task :load => :environment do
  Project.fetch!
end

desc "Enqueue all project loading"
task :enqueue_all => :environment do
  projs = Snapshooter.snapshot_all
  puts "Enqueued #{projs.length} jobs"
end

desc "Enqueue recursive task to continuously load projects every hour"
task :enqueue => :environment do
  SnapshotQueuer.make_initial_job
  puts "Initial job will run immediately and requeue itself every 60 minutes"
end
