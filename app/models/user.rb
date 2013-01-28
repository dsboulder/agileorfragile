class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :tracker_token
  # attr_accessible :title, :body

  validates_presence_of :tracker_token

  has_many :projects

  def fetch_projects
    dead_projects = Project.all
    Tracker::Project.all.each do |proj|
      project = projects.find_or_create_by_tracker_id(proj.id)
      project.name = proj.name
      project.all_labels = proj.labels.downcase
      project.save!
      dead_projects.delete(project)
    end
    dead_projects.map &:destroy
  end
end
