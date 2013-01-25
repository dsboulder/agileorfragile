module Tracker
  class Iteration < Base
    self.site = self.site_base + "/projects/:project_id"

    def to_iter(record_project, taken_on)
      now = Time.now
      labelings = {}
      ::Iteration.new(:start => start, :finish => finish, :number => number, :taken_on => taken_on).tap do |i|
        i.project = record_project

        # derive iteration type
        i.kind = case true
          when i.finish < now then "done"
          when i.start >= now then "backlog"
          else "current"
        end

        # create story records
        i.stories = stories.map do |s|
          ::Story.new.tap do |story|
            Tracker::Iteration::Story.schema.except("description", "labels", "created_at").keys.each do |key|
              story.send("#{key}=", s.send(key))
            end
            story.tracker_labels = s.labels
            story.tracker_created_at = s.created_at
            story.project = record_project
            story.created_at = s.created_at
            story.updated_at = s.updated_at
            story.taken_on = taken_on

            s.labels_list.each do |l|
              # find or create a global Label object
              label = Label.find_or_create_by_name(:name => l.downcase)

              # make a connection between this story and the Label
              story.labelings.build(:label => label, :project => record_project, :taken_on => taken_on)
            end
          end
        end
      end
    end

    class Story < Base
      self.site = Iteration.site

      schema do
        string 'name'
        string 'labels'
        string 'current_state'
        string 'story_type'
        string 'owned_by'
        string 'requested_by'
        string 'description'
        integer 'estimate'
      end

      def estimate
        (super || "-1").to_i
      end

      def labels_list
        (labels || "").split(",")
      end
    end
  end
end
