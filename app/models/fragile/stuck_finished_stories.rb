module Fragile
  class StuckFinishedStories < StuckStories
    def self.abstract_class
      false
    end

    def self.state
      "finished"
    end

    def description
      <<-TXT
      Stories should be delivered as quickly as possible after being finished.  Automated deployment
      procedures can help when the team forgets to frequently deliver.
      TXT
    end
  end
end
