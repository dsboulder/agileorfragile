module Fragile
  class VelocityVariance < Base
    def initialize(project)
      super
      @velocities = project.velocities
    end

    def run
      last4 = @velocities.reverse.first(4).reverse
      vel4 = last4.map do |vel|
        vel[:velocity].to_f
      end
      avg = (vel4.sum / vel4.length.to_f)
      variance_factors = vel4.map{|v| (avg - v).abs / avg * 100 }
      avg_variance = variance_factors.sum.to_f / variance_factors.length.to_f
      messages = []
      messages << "Your average velocity variance (#{avg_variance.round}%) should be less than 30%" if avg_variance > 30.0
      messages << "Your worst velocity variance (#{variance_factors.max.round}%) should be less than 50%" if variance_factors.max > 50.0
      {
          :active => messages.any?,
          :metrics => [
              {name: 'Average velocity', value: avg, units: 'points'},
              {name: 'Lowest velocity', value: vel4.min, units: 'points'},
              {name: 'Highest velocity', value: vel4.max, units: 'points'},
              {name: 'Average velocity variance', value:avg_variance.round, units: 'percent'},
              {name: 'Worst velocity variance', value:variance_factors.max.round, units: 'percent'}
          ],
          :bar_graph => {
                  data: last4.map do |vel|
                    v = vel[:velocity].to_f
                    {x: vel[:iteration].number,
                     y: v,
                    class: (avg - v).abs / avg * 100 >= 50.0 ? "bad" : "good"}
                  end,
                  x_axis: 'Recent Iterations',
                  y_axis: 'Velocity',
                  title: "Velocity"
          },
          :messages => messages,
          :measured => "Your last #{last4.length} velocities are compared with the average velocity"
      }
    end

    def runnable
      @velocities.length >= project.number_of_iterations_for_velocity * 2 ?
          true :
          "Need at least #{project.number_of_iterations_for_velocity * 2} past velocities, but only found #{@velocities.length}"
    end

    def name
      "High velocity variance"
    end

    def description
      "More than its absolute value, having a consistent velocity from week to week is important for project planning."
    end
  end
end
