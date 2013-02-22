class Comparison < ActiveRecord::Base
  
    belongs_to :channel
    
    named_scope :found_house,         :conditions => { :found_house => true },  :order => :rounded
    named_scope :found_title,         :conditions => { :found_house => false, :found_title => true}, :order => :rounded
    named_scope :contained_title,     :conditions => { :contained => true, :found_title => false}, :order => :rounded
    named_scope :not_found,           :conditions => { :found_house => false, :contained => false}, :order => :rounded

   FILTERS = [
     {:scope => "all",                :label => "All"},
     {:scope => "found_house",        :label => "Already in database"},
     {:scope => "found_title",        :label => "Found title"},
     {:scope => "contained_title",    :label => "Contained title"},
     {:scope => "not_found",          :label => "Not found"}    
   ]
  
  
   def self.filter_display
     filters = []
     FILTERS.each do |filter|
       filters << [[filter[:label]], filter[:scope]]
     end
     filters
   end
  
  def self.add_prog(playlist, press)
    comp = Comparison.new
    comp.start = playlist.start
    comp.rounded = playlist.rounded
    comp.long_title = playlist.long_title
    comp.house_no = playlist.house_no
  #  comp.found_house = house_exists(playlist.house_no)
    comp.found_house = house_exists_and_local_title_not_nil(playlist.house_no, playlist.playlist_filename.channel)
    comp.channel = playlist.playlist_filename.channel
    if press.nil?
      comp.original_title = 'Not Found'
      comp.contained = false
      comp.found_title = false
    else
      comp.press_start = press.start
      comp.original_title = press.original_title
      comp.danish_title = press.display_title
      comp.contained = same_title(comp.long_title, press.original_title)
      comp.found_title = title_exists(press.original_title)
    end
    comp.save
  end
  
  def self.house_exists_and_local_title_not_nil(house_number, channel)
    h = House.find_by_house_number(house_number)
    if h
      case channel.language.name
      when 'Danish'
        t = h.title.danish
      when 'Swedish'
        t = h.title.swedish
      when 'Hungarian'
        t = h.title.hungarian
      when 'Norwegian'
        t = h.title.norwegian
      end
      !t.nil? && !t.empty?
    else
      !h.nil?
    end
  end
  
  def row_css
    if self.found_house
      "normal"
    elsif self.found_title
      "titled"
    elsif self.contained
      "contained"
    else
      "missing"
    end
  end
  
  def original_title_as_param
    if original_title.upcase == "NOT FOUND"
      ""
    else
      original_title
    end
  end
  
  def found?
    self.found_house || self.found_title || self.contained
  end
  
  private
  
  def self.same_title(playlist_title, press_title)
    contained = playlist_title.upcase.include? press_title.upcase
    if !contained
      test = press_title.upcase
      Ignore.all.each do |w|
        test = test.gsub(w.word.upcase,'').squeeze(" ").strip
        if playlist_title.upcase.include? test
          contained = true
        end
      end
    end
    contained
  end
  
  def self.house_exists(house_number)
    h = House.find_by_house_number(house_number)
    !h.nil?
  end
  
  def self.title_exists(title)
    t=Title.find_by_english(title)
    !t.nil?
  end
end
