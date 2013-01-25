class Story < ActiveRecord::Base
  attr_accessible :current_state, :tracker_labels, :name, :owned_by, :requested_by, :tracker_id, :url, :project_id, :story_type, :tracker_created_at
  has_many :labelings
  has_many :labels, :through => :labelings
  belongs_to :project
  belongs_to :iteration

  def serializable_hash(options)
    super(:methods => :label_ids)
  end
end
