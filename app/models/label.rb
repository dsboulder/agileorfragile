class Label < ActiveRecord::Base
  attr_accessible :name
  has_many :labelings
  has_many :stories, :through => :labelings

  validates_presence_of :name
  validates_uniqueness_of :name
end
