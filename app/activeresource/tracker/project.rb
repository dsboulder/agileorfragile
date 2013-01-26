module Tracker
  class Project < Base
    self.site = self.site_base
    schema do
      string "name"
      string "labels"
      integer "current_velocity"
    end

    def iterations(filter = :current, params = {})
      Tracker::Iteration.all(:from => filter, :params => {:project_id => id}.merge(params))
    end

    def current_velocity
      (super || default_velocity).to_i
    end
  end
end
