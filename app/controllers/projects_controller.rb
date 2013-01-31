class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @projects = current_user.projects
  end

  def show
    @project = current_user.projects.find(params[:id])
    @velocities = @project.velocities

    respond_to do |format|
      format.html {}
      format.json { render :json => @project.to_json(:methods => [:velocities, :fragiles]) }
    end
  end
end
