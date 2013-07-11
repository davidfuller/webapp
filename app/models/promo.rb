class Promo < ActiveRecord::Base
    
    has_and_belongs_to_many :media_files
    belongs_to :title
    belongs_to :promo_type
    
    default_scope :order => :name

    validates_uniqueness_of :name, :message => " is already in the system"
    validates_presence_of :title_id
    validates_presence_of :promo_type_id
    validates_presence_of :name

  def self.past_last_use(params)
    
    if Useful.date?(params[:last_use_date])
      last_use_date = Date.parse(params[:last_use_date]).strftime('%F')
      if params[:search]
        paginate  :per_page => 12, :page =>params[:page],
                  :conditions => ['name LIKE ? and DATE(last_use) <= ?', "%#{params[:search]}%", last_use_date]
      else
        paginate  :per_page => 12, :page =>params[:page],
                  :conditions => ['DATE(last_use) <= ?', last_use_date]
      end
    else
      if params[:search]
        paginate  :per_page => 12, :page =>params[:page],
                  :conditions => ['name LIKE ?', "%#{params[:search]}%"]
      else
        paginate  :all, :per_page => 12, :page =>params[:page]
      end
    end
  end

  def self.search(search, page)
    if search
      paginate  :per_page => 12, :page =>page,
                :conditions => ['name LIKE ?', "%#{search}%"]
    else
      paginate  :all, :per_page => 12, :page =>page
    end
  end 

  def self.find_with_title_id(id, title_id)
    p = find(id)
    if title_id
      p.title_id=title_id
    end
    p
  end

  def self.new_with_default_times
    p = Promo.new
    p.first_use = Date.today.to_datetime.advance(:days => 7, :hours => 5)
    p.last_use = p.first_use.advance(:months => 6)
    p
  end    
  
  def self.filter_expired(params)
    last_use_date = Date.parse(params[:last_use]).strftime('%F')
    find(:all, :conditions => ['DATE(last_use) >= ? ' , last_use_date])
  end

  def add_file(media_file)
    media_files << media_file
  end
  
  def self.change_last_use_and_media(id, new_last_use)
    p = find(id)
    p.last_use = new_last_use
    num_added = 0
    if p.save
      p.media_files.each do |media|
        m = MediaFile.find(media.id)
        m.last_use = new_last_use
        m.save
        num_added += 1
      end
      num_added
    else
      nil
    end
  end
  
  
  
end
