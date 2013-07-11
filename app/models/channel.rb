class Channel < ActiveRecord::Base
  
  has_many :promos
  has_many :press_lines
  has_many :bugs
  has_many :media_folders
  has_many :countdown_ipps
  has_many :schedule_files
  has_many :schedule_comparisons
  has_many :playlist_filenames
  has_many :comparisons
  has_many :cross_channel_priorities
  has_many :dynamic_specials
  
  validates_presence_of :name
  default_scope :order => :name
  
  
  def self.display
    all(:select => :name).map{|m| m.name}
  end
  
  
end
