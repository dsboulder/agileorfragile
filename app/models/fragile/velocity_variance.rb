module Fragile
  class VelocityVariance < Base
    def initialize(project)
      super
      @velocities = project.velocities
    end

    def run
      last4 = @velocities.reverse.first(4)
      vel4 = last4.map do |vel|
        vel[:velocity].to_f
      end
      avg = (vel4.sum / vel4.length.to_f)
      variance_factors = vel4.map{|v| (avg - v).abs / avg * 100 }
      avg_variance = variance_factors.to_f / variance_factors.length.to_f
      messages = []
      messages << "Your average velocity variance (#{avg_variance.round}%) should be less than 30%" if avg_variance > 0.3
      messages << "Your maximum velocity variance (#{variance_factors.max.round}%) should be less than 50%" if variance_factors.max > 0.5
      {
          :active => messages.any?,
          :metrics => {
              :average_velocity => avg,
              :average_velocity_variance => avg_variance,
              :max_velocity_variance => variance_factors.max
          },
          :messages => messages,
          :measured => "Your last #{last4.length} velocities (average #{avg.round}) are compared with each other"
      }
    end

    def runnable
      @velocities.length >= project.number_of_iterations_for_velocity * 2 ?
          true :
          "Need at least #{project.number_of_iterations_for_velocity * 2} past velocities, but only found #{@velocities.length}"
    end

    def description
      "More than its absolute value, having a consistent velocity from week to week is important for project planning."
    end
  end
end