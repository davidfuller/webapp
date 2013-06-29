class PromoType < ActiveRecord::Base

  has_many :promos
  default_scope :order => :name
  
  
end
