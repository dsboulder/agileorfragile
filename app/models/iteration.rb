class Iteration < ActiveRecord::Base
  attr_accessible :finish, :kind, :number, :project_id, :start, :taken_on, :iteration_length, :team_strength
  has_many :stories
  belongs_to :project
  scope :taken_on, lambda { |taken_on| where(:taken_on => taken_on) }
  scope :taken_on_weekday, where("WEEKDAY(taken_on) < 5")
  scope :done, where(kind: 'done')
  scope :current, where(kind: 'current')
  scope :backlog, where(kind: 'backlog')

  def serializable_hash(options)
    super(:methods => :story_ids)
  end

  def points_accepted
    stories.in_state("accepted").estimated.sum(:estimate) || 0
  end

  def velocity_contribution
    points_accepted / team_strength
  end

  def velocity()
    previous_iterations = self.previous_n(project.number_of_iterations_for_velocity)
    if previous_iterations.any?
      [1.0, (previous_iterations.collect(&:velocity_contribution).sum / previous_iterations.length).floor].max
    else
      nil
    end
  end

  def previous_n(n)
    project.iterations.taken_on(taken_on).where(["number < ? AND team_strength > ?", number, 0.0]).order("number DESC").limit(n).sort_by(&:number)
  end
end
