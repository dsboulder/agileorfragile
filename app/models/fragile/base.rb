module Fragile
  class Base
    attr_reader :project
    def initialize(project)
      @project = project
    end

    def self.run_all(project)
      Fragile::Base.subclasses.map do |subclass|
        i = subclass.new(project)
        runnable = i.runnable
        h = {:runnable => runnable.is_a?(TrueClass)}
        h[:description] = i.description
        h[:results] = i.run if h[:runnable]
        h[:norun_message] = runnable if !h[:runnable]
        h
      end
    end
  end
end
