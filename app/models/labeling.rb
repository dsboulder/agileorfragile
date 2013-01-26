class Labeling < ActiveRecord::Base
  attr_accessible :project_id, :story_id, :label_id, :project, :label, :story, :taken_on
  belongs_to :project
  belongs_to :story
  belongs_to :label
  scope :taken_on, lambda { |taken_on| where(:taken_on => taken_on) }
end
