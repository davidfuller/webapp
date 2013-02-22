class House < ActiveRecord::Base
  belongs_to :title
  belongs_to :series_number
  
  default_scope :order => :house_number
    
  validates_uniqueness_of :house_number, :message => " is already in the system"
  validates_presence_of :title_id
  
  attr_accessor :source
  attr_accessor :schedule_comparison
  
  def self.search(search, page)
    if search
      paginate  :per_page => 16, :page =>page,
                :conditions => ['house_number LIKE ?', "%#{search}%"]
    else
      paginate  :per_page => 16, :page =>page
    end
  end 

  
  def self.add_from_comparison(comparison, title)
    added = 0
    issues = 0
    success = false
    h = new
    h.title = title
    h.house_number = comparison[:house_number]
    if comparison[:series_number]
      s = SeriesNumber.find_or_create_by_series_number(comparison[:series_number])
      if s
        h.series_number = s
      end
    end
    notice = ''
    if h.save
      added += 1
      success = true
    else
      h.errors.each_full do |err|
        if err.upcase != "HOUSE NUMBER  IS ALREADY IN THE SYSTEM"
          logger.debug "============>" + err.upcase
          issues += 1
          notice += err + ". "
        end
      end
    end
    {:added => added, :issues => issues, :notice => notice, :success => success}
  end
  
  
end
