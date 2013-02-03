module Fragile
  class OwnerStartedTooManyStories < Base
    def initialize(project)
      super
      @stories_in_state = project.stories.taken_on(project.last_snapshot_at.to_date).in_state("started")
    end

    def run
      active = false
      by_owner = @stories_in_state.group_by(&:owned_by)
      messages = []
      by_owner.each do |owner,stories|
        messages << "#{owner} is currently owning #{stories.length} stories: #{stories.collect{|s| "##{s.tracker_id}"}.join(", ")}" if stories.length > 1
        active = true if stories.length > 2
      end
      lengths = by_owner.values.collect(&:length)
      {
          :active => active,
          :metrics => [
              {name: "Average per owner", value: (lengths.sum.to_f / lengths.length).round(1), units: 'stories'},
              {name: "Highest per owner", value: lengths.max, units: 'stories'}
          ],
          :bar_graph => {
                  data: by_owner.map do |owner,stories|
                    if stories.length > 1
                      {x: owner,
                       y: stories.length,
                      class: stories.length > 2 ? "bad" : "good"}
                    end
                  end.compact,
                  x_axis: 'Started stories owned by a single user',
                  y_axis: 'Velocity',
                  title: "Velocity"
          },
          :messages => messages,
          :measured => "The #{@stories_in_state.length} currently started stories are grouped by owner."
      }
    end

    def runnable
      @stories_in_state.any? ?
          true :
          "Need at least 1 started story"
    end

    def name
      "Owner started too many stories at once"
    end

    def description
      "Story owners should have only 1 in-progress story at a time. This ensures that people finish one " +
          "item before starting the next.  If a block of stories truly cannot be done independently, then they " +
              "probably should not be broken down."

    end
  end
end
