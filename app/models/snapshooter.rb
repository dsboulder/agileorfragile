class Snapshooter < Struct.new(:project_id)
  def snapshot
    Project.find(project_id).fetch!
  end
  handle_asynchronously :snapshot

  def self.snapshot_all
    projects = Project.all
    projects.each do |project|
      Snapshooter.new(project.id).snapshot
    end
    projects
  end
end