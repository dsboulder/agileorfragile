class Project < ActiveRecord::Base
  attr_accessible :tracker_id, :enabled, :name, :enabled_labels, :enabled_labels_list, :all_labels, :current_velocity
  has_many :iterations, :dependent => :delete_all, :order => :number
  has_many :stories, :dependent => :delete_all
  has_many :labelings, :dependent => :delete_all
  has_many :labels, :through => :labelings

  scope :enabled, where(:enabled => true)

  def self.fetch!
    Project.enabled.each do |proj|
      begin
        proj.fetch!
      rescue
        puts "Unable to fetch project #{proj.id}: #{$!}"
        puts $!.backtrace.join("\n\t")
        raise
      end
    end
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
    tracker_proj = Tracker::Project.find(tracker_id)
    iters = tracker_proj.iterations(:current_backlog)
    transaction do
      # kill existing data
      stories.clear
      iterations.clear
      labelings.clear

      # insert new data
      iters.each do |i|
        i.to_iter(self).save!
      end
      self.update_attributes!(:current_velocity => tracker_proj.current_velocity)
    end

    iterations.reload
    self
  end
end
