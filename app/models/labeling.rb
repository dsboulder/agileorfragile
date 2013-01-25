class Labeling < ActiveRecord::Base
  attr_accessible :project_id, :story_id, :label_id, :project, :label, :story
  belongs_to :project
  belongs_to :story
  belongs_to :label
end
