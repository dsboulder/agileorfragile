class Project < ActiveRecord::Base
  attr_accessible :tracker_id, :enabled, :name, :enabled_labels, :enabled_labels_list, :all_labels, :current_velocity, :last_snapshot_at
  has_many :iterations, :dependent => :delete_all
  has_many :stories, :dependent => :delete_all
  has_many :labelings, :dependent => :delete_all
  has_many :labels, :through => :labelings

  scope :enabled, where(:enabled => true)

  def self.fetch!
    Project.all.each do |proj|
      begin
        proj.fetch!
      rescue
        puts "Unable to fetch project #{proj.id}: #{$!}"
        puts $!.backtrace.join("\n\t")
        raise
      end
    end
  end

  def number_of_iterations_for_velocity
    3
  end

  def enabled_label_ids
    enabled_labels_list.any? ? Label.where(:name => enabled_labels_list).collect(&:id) : []
  end

  def enabled_labels_list
    enabled_labels.split(",").map(&:strip)
  end

  def enabled_labels_list= newval
    self.enabled_labels = newval.reject(&:blank?).join(",")
  end

  def all_labels_list
    all_labels.split(",").map(&:strip)
  end

  def fetch!
    now = Date.today
    tracker_proj = Tracker::Project.find(tracker_id)
    iters = tracker_proj.iterations(:current_backlog)
    done_iters = tracker_proj.iterations(:done, :offset => -8)
    transaction do
      # kill existing data
      stories.taken_on(now).delete_all
      iterations.taken_on(now).delete_all
      labelings.taken_on(now).delete_all

      # insert new data
      (done_iters + iters).each do |i|
        i.to_iter(self, now).save!
      end
      self.update_attributes!(:current_velocity => tracker_proj.current_velocity, :last_snapshot_at => now)
    end

    iterations.reload
    self
  end

  def velocities(taken_on = last_snapshot_date)
    current_iter = iterations.taken_on(taken_on).current.first
    done_iters = current_iter.previous_n(8 - number_of_iterations_for_velocity)
    (done_iters + [current_iter]).inject([]) do |memo, iter|
      memo << {iteration: iter, velocity: iter.velocity, accepted: iter.points_accepted}
    end
  end

  def last_snapshot_date
    last_snapshot_at.to_date
  end
end
