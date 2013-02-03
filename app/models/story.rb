class Story < ActiveRecord::Base
  attr_accessible :current_state, :tracker_labels, :name, :owned_by, :requested_by, :tracker_id, :url, :project_id, :story_type, :tracker_created_at, :taken_on, :estimate
  has_many :labelings
  has_many :labels, :through => :labelings
  belongs_to :project
  belongs_to :iteration

  scope :taken_on, lambda { |taken_on| where(:taken_on => taken_on) }
  scope :taken_before, lambda { |taken_on| where(["taken_on < ?", taken_on]).order("taken_on DESC") }
  scope :taken_on_weekday, where("WEEKDAY(taken_on) < 5")
  scope :in_state, lambda { |state| where(:current_state => state) }
  scope :estimated, where("estimate > -1")

  def serializable_hash(options)
    super(:methods => :label_ids)
  end

  def previous_snapshots(limit = 5)
    conditions = tracker_id ? {:tracker_id => tracker_id} : {:name => name}
    project.stories.where(conditions).taken_on_weekday.taken_before(taken_on).limit(limit)
  end
end
