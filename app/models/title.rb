class Title < ActiveRecord::Base
  
  has_many :houses, :dependent => :delete_all
  has_many :promos, :dependent => :delete_all
  has_many :cross_channel_priorities
  
  validates_presence_of :schedule_title
  default_scope :order => :schedule_title
  
  attr_accessor :source
  attr_accessor :channel
  attr_accessor :schedule_comparison_id
  attr_accessor :press_line_id
    
  def self.search(search, page)
    if search
      paginate  :per_page => 12, :page =>page,
                :conditions => ['schedule_title LIKE ?', "%#{search}%"]
    else
      paginate  :per_page => 12, :page =>page
    end
  end 
      
end
