module Fragile
  class StuckStartedStories < StuckStories
    def self.abstract_class
      false
    end

    def self.state
      "started"
    end

    def description
      <<-TXT
      Leaving a story started for too long usually means that it needs to be broken down, it's blocked,
      or it's been forgotten.  A story should be unstarted if it's not being worked on.
      TXT
    end
  end
end
