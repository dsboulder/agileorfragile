module Fragile
  class StuckDeliveredStories < StuckStories
    def self.abstract_class
      false
    end

    def self.state
      "delivered"
    end

    def description
      <<-TXT
      Stories should be either accepted or rejected immediately after delivery. Slow acceptance process
      results in the story owner losing context on the story, which becomes problematic when rejections
      take place.
      TXT
    end
  end
end
