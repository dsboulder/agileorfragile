class Iteration < ActiveRecord::Base
  attr_accessible :finish, :kind, :number, :project_id, :start
  has_many :stories
  belongs_to :project

  def serializable_hash(options)
    super(:methods => :story_ids)
  end
end
