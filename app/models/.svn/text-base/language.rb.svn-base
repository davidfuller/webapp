class Language < ActiveRecord::Base
  
  has_one :channel
  validates_presence_of :name, :position
  default_scope :order => :position
  
  def self.display
    all(:select => :name).map{|m| m.name}
  end
  
      
  
end
