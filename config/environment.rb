# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Agileorfragile::Application.initialize!

if !Rails.configuration.cache_classes
  puts "Singlethreaded, not starting worker"
else
  $worker_thread = Thread.new do
    sleep 10
    begin
      $worker = Delayed::Worker.new(quiet: false)
      $worker.name_prefix = "#{Process.pid}:#{Thread.current.object_id}"
      def $worker.trap(sig)
        # do nothing, that'll teach that worker
      end
      $worker.start
    rescue
      puts $!
    end
  end

  module Thin
    class Server
      def stop_with_stuff
        if $worker
          puts "Stopping worker"
          $worker.stop
          $worker_thread.join
          puts "Stopped worker"
        end
      ensure
        stop_without_stuff
      end
      alias_method_chain :stop, :stuff

      def stop_with_stuff!
        if $worker
          puts "Stopping worker"
          $worker.stop
          $worker_thread.join
          puts "Stopped worker"
        end
      ensure
        stop_without_stuff!
      end
      alias_method_chain :stop!, :stuff
    end
  end
end
