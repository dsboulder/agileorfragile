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

task :fix_story_ids => :environment do
  Project.transaction do
    Project.all.each do |proj|
      proj.stories.taken_on(proj.last_snapshot_at.to_date).each do |story|
        if story.tracker_id
          proj.stories.where({name: story.name}).update_all({tracker_id: story.tracker_id})
        end
      end
    end
  end
end
