class SnapshotQueuer
  def perform
    Project.where(["last_snapshot_at IS NULL OR DATE(last_snapshot_at) < ?", Date.today]).each do |project|
      Snapshooter.new(project.id).snapshot
      puts "Enqueued snapshot for project #{project.id}"
    end
    Delayed::Job.enqueue SnapshotQueuer.new, :run_at => 1.hour.from_now
  end

  def self.make_initial_job
    SnapshotQueuer.new.perform
  end
end