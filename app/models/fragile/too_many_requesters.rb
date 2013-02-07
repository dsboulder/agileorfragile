module Fragile
  class TooManyRequesters < Base
    def initialize(project)
      super
      @stories_to_check = project.stories.features.taken_on(project.last_snapshot_at.to_date).in_state(["delivered", "rejected", "finished", "started", "unstarted"])
    end

    def run
      by_requester = @stories_to_check.group_by(&:requested_by)
      lengths = by_requester.values.collect(&:length)
      messages = []
      messages << "There are currently #{by_requester.length} feature requesters in the backlog" if lengths.length > 2

      lengths = by_requester.values.collect(&:length)
      {
          :active => messages.any?,
          :metrics => [
              {name: "Average stories per requester", value: (lengths.sum.to_f / lengths.length).round(1), units: 'stories'},
              {name: "Highest per requester", value: lengths.max, units: 'stories'},
              {name: "Lowest per requester", value: lengths.min, units: 'stories'}
          ],
          :bar_graph => {
                  data: by_requester.map do |requester,stories|
                    if stories.length > 0
                      {x: requester,
                       y: stories.length,
                      class: stories.length == lengths.max ? "good" : "bad"}
                    end
                  end.compact,
                  x_axis: 'Started by requester'
          },
          :messages => messages,
          :measured => "The #{@stories_to_check.length} currently active and backlog features are grouped by owner."
      }
    end

    def runnable
      @stories_to_check.any? ?
          true :
          "Need at least 1 active/backlog feature"
    end

    def name
      "Too many requesters in the backlog"
    end

    def description
      "The backlog features should principally be managed by one product manager.  Occasionally a role for a 2nd owner can be " +
              "acceptable when they have clearly non-overlapping domains.  Even when there is a single product owner, failing " +
              "to set requesters accurately results in the PM missing email notifications. On the other hand, chores are usually requested by " +
              "many members of the team, and bugs are frequently found by everyone."
    end
  end
end
