module Fragile
  class StuckStories < Base
    attr_reader :stories_in_state

    def self.abstract_class
      true
    end

    def initialize(project)
      super
      @past_snapshots_count = project.past_snapshots_count
      @stories_in_state = project.stories.taken_on(project.last_snapshot_at.to_date).in_state(self.class.state)
    end

    def run
      messages = []
      state_days = {}
      num_days = 0
      stories_in_state.each do |story|
        prev_snapshots = story.previous_snapshots(20)
        state_snapshots = prev_snapshots.select { |s| s.current_state == self.class.state }
        num_days += state_snapshots.length
        state_days[state_snapshots.length] ||= 0
        state_days[state_snapshots.length] += 1
        messages << "Story \"#{story.name}\" ##{story.tracker_id} was #{self.class.state} #{state_snapshots.size} days ago" if state_snapshots.length > 2
      end
      {
              :active => messages.any?,
              :metrics => [
                      {name: "Average current stories #{self.class.state} for", value: (num_days.to_f / stories_in_state.length).round(1), units: 'days'},
                      {name: "Maximum days a story has been #{self.class.state} for", value: state_days.keys.max, units: 'days'}
              ],
              :bar_graph => {
                      data: state_days.keys.sort.map do |days|
                        {x: days,
                         y: state_days[days],
                         class: days > 2 ? "bad" : "good"}
                      end,
                      title: "Number of currently #{self.class.state} stories that have been #{self.class.state} for X days",
                      x_axis: "Days stories has been #{self.class.state}"
              },
              :messages => messages,
              :measured => "Stories that are currently #{self.class.state} were analyzed using #{[@past_snapshots_count, 20].min} days of historical snapshots"
      }
    end

    def runnable
      @past_snapshots_count >= 4 ?
              (stories_in_state.length > 0 ? true : "There are no stories currently #{self.class.state}") :
              "Need at least 4 business days worth of past story snapshots, but only found #{@past_snapshots_count}"
    end

    def name
      "Stuck #{self.class.state} stories"
    end
  end
end
