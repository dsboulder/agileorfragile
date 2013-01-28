module Fragile
  class VelocityVariance < Base
    def initialize(project)
      super
      @velocities = project.velocities
    end

    def run
      last4 = @velocities.reverse.first(4)
      last4.map do |vel|
        vel[:velocity]
      end
      avg = (last4.sum.to_f / last4.length.to_f)

    end

    def runnable?
      @velocities.length > project.number_of_iterations_for_velocity * 2
    end
  end
end