module Fragile
  class Base
    attr_reader :project
    def initialize(project)
      @project = project
    end
  end
end