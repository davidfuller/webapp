class Promo < ActiveRecord::Base
    
    has_and_belongs_to_many :media_files
    belongs_to :channel
    default_scope :order => :name

    validates_presence_of :name

  def self.search(search, page)
    if search
      paginate  :per_page => 12, :page =>page,
                :conditions => ['name LIKE ?', "%#{search}%"]
    else
      paginate  :all, :per_page => 12, :page =>page
    end
  end 
 
end
