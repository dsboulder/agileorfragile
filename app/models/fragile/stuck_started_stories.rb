module Fragile
  class StuckStartedStories < Base
    attr_reader :started_stories

    def initialize(project)
      super
      @past_snapshots_count = project.past_snapshots_count
      @started_stories = project.stories.taken_on(project.last_snapshot_at.to_date).in_state("started")
    end

    def run
      messages = []
      started_days = {}
      num_started_days = 0
      started_stories.each do |story|
        prev_snapshots = story.previous_snapshots(20)
        started_snapshots = prev_snapshots.select { |s| s.current_state == "started" }
        num_started_days += started_snapshots.length
        started_days[started_snapshots.length] ||= 0
        started_days[started_snapshots.length] += 1
        messages << "Story \"#{story.name}\" ##{story.tracker_id} was started #{started_snapshots.size} days ago" if started_snapshots.length > 2
      end
      {
              :active => messages.any?,
              :metrics => [
                      {name: 'Average current stories started for', value: (num_started_days.to_f / started_stories.length).round(1), units: 'days'},
                      {name: 'Maximum days a story has been started for', value: started_days.keys.max, units: 'days'}
              ],
              :bar_graph => {
                      data: started_days.keys.sort.map do |days|
                        {x: days,
                         y: started_days[days],
                         class: days > 2 ? "bad" : "good"}
                      end,
                      title: 'Number of started stories that have been open for X days',
                      x_axis: 'Days story has been started'
              },
              :messages => messages,
              :measured => "Stories that are currently started were analyzed using #{[@past_snapshots_count, 20].min} days of historical snapshots"
      }
    end

    def runnable
      @past_snapshots_count >= 4 ?
              (started_stories.length > 0 ? true : "There are no stories currently started") :
              "Need at least 4 business days worth of past story snapshots, but only found #{@past_snapshots_count}"
    end

    def name
      "Stuck started stories"
    end

    def description
      <<-TXT
      Leaving a story started for too long usually means that it needs to be broken down, it's blocked,
      or it's been forgotten.  A story should be unstarted if it's not being worked on.
      TXT
    end
  end
end
