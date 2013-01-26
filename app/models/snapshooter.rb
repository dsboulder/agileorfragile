class Snapshooter < Struct.new(:project_id)
  def snapshot
    Project.find(project_id).fetch!
  end
  handle_asynchronously :snapshot

  def self.snapshot_all
    Project.all.each do |project|
      Snapshooter.new(project.id).snapshot
    end
  end
end