class Version < ActiveRecord::Base

  belongs_to :promo
  belongs_to :producer
  
  default_scope :order => :promo_id
  
end
