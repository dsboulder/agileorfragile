class Iteration < ActiveRecord::Base
  attr_accessible :finish, :kind, :number, :project_id, :start, :taken_on
  has_many :stories
  belongs_to :project
  scope :taken_on, lambda { |taken_on| where(:taken_on => taken_on) }
  scope :done, where(kind: 'done')
  scope :current, where(kind: 'current')
  scope :backlog, where(kind: 'backlog')

  def serializable_hash(options)
    super(:methods => :story_ids)
  end

  def points_accepted
    stories.in_state("accepted").estimated.sum(:estimate) || 0
  end

  def velocity()
    previous_iterations = self.previous_n(project.number_of_iterations_for_velocity)
    logger.debug("prev: #{previous_iterations.collect(&:number)}")
    if previous_iterations.any?
      logger.debug("Iteration #{number} velocity = sum(#{previous_iterations.collect(&:points_accepted)}) / #{previous_iterations.length}")
      previous_iterations.collect(&:points_accepted).sum / previous_iterations.length
    else
      nil
    end
  end

  def previous_n(n)
    project.iterations.taken_on(taken_on).where(["number < ?", number]).order("number DESC").limit(n)
  end
end
