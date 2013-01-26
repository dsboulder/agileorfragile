class Story < ActiveRecord::Base
  attr_accessible :current_state, :tracker_labels, :name, :owned_by, :requested_by, :tracker_id, :url, :project_id, :story_type, :tracker_created_at, :taken_on, :estimate
  has_many :labelings
  has_many :labels, :through => :labelings
  belongs_to :project
  belongs_to :iteration

  scope :taken_on, lambda { |taken_on| where(:taken_on => taken_on) }
  scope :in_state, lambda { |state| where(:current_state => state) }
  scope :estimated, where("estimate > -1")

  def serializable_hash(options)
    super(:methods => :label_ids)
  end
end
