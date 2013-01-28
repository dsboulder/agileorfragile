class JobsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    @existing_job = Delayed::Job.where("handler LIKE ?", '%SnapshotQueuer%').first
  end

  def index
  end

  def create
    if !@existing_job
      SnapshotQueuer.make_initial_job
      flash[:notice] = "Job created!"
    else
      flash[:error] = "Job already exists with ID #{@existing_job.id}!"
    end
    redirect_to root_path
  end
end
