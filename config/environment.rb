# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Agileorfragile::Application.initialize!

Thread.new do
  begin
    worker = Delayed::Worker.new({})
    worker.name_prefix = "#{Process.pid}:#{Thread.current.object_id}"
    puts "Starting worker"
    worker.start
  rescue
    puts $!
  end
end

