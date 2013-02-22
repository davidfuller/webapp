class Title < ActiveRecord::Base
  
  has_many :houses, :dependent => :delete_all
  has_many :promos, :dependent => :delete_all
  has_many :cross_channel_priorities
  
  validates_presence_of :english
  default_scope :order => :english
  
  attr_accessor :source
  attr_accessor :channel
  attr_accessor :schedule_comparison_id
  attr_accessor :press_line_id
    
  def self.search(search, page)
    if search
      paginate  :per_page => 12, :page =>page,
                :conditions => ['english LIKE ?', "%#{search}%"]
    else
      paginate  :per_page => 12, :page =>page
    end
  end 
  
    
  def eop_display
    if eop
      "Own"
    else
      "None"
    end
  end
  
  def eop_boolean
    if eop
      "True"
    else
      "False"
    end
  end   
  
  def has_language?(language_name)
    case language_name
    when "Danish"
      not danish.blank?
    when "Swedish"
      not swedish.blank?
    when "Hungarian"
      not hungarian.blank?
    when "Norwegian"
      not norwegian.blank?
    else
      false
    end
    
  end
  
  def self.add_from_comparison(comparison)
    notice = ''
    added = 0
    house_added = 0
    issues = 0
    house_issues = 0
    success = false
    if not comparison[:found]
      notice += comparison[:title] + ' has no title to add to database. '
      issues += 1
    else 
      if comparison[:found_house] 
        notice += 'Title and House No: ' + comparison[:house_number] + ' already in database. '
        issues += 1
      else
        h = House.find_by_house_number(comparison[:house_number])
        if h then
          #if we get here, we've found a house number and we'll add the local title to the title record
          @title = find(h.title_id)
          stats = set_local_title(comparison[:local_title], comparison[:channel])
          notice += stats[:notice]
          issues += stats[:issues]
          if stats[:do_save]
            if @title.save
              added +=1
              success = true
            else
              @title.errors.each_full do |err|
                issues += 1
                notice += err + ". "
              end
            end
          else
            success = true
          end
        else
          #if we get here, there is no associated house number
          @title = find_by_english(comparison[:original_title])
          
          if @title
            stats = set_local_title(comparison[:local_title], comparison[:channel])
            notice += stats[:notice]
            issues += stats[:issues]
            if stats[:do_save]
              if @title.save
                added +=1
                stats = House.add_from_comparison comparison, @title
                notice += stats[:notice]
                house_added += stats[:added]
                house_issues += stats[:issues]
                success = stats[:success]
              else
                @title.errors.each_full do |err|
                  issues += 1
                  notice += err + ". "
                end
              end
            else
              stats = House.add_from_comparison comparison, @title
              notice += stats[:notice]
              house_added += stats[:added]
              house_issues += stats[:issues]
              success = stats[:success]  
            end
            
          else
            #if we get here we need to create a new title
            @title = new
            @title.english = comparison[:original_title]
            stats = set_local_title(comparison[:local_title], comparison[:channel])
            notice += stats[:notice]
            issues += stats[:issues]
            if @title.save
              added += 1
              stats = House.add_from_comparison comparison, @title
              notice += stats[:notice]
              house_added += stats[:added]
              house_issues += stats[:issues]
              success = stats[:success]
            else
              @title.errors.each_full do |err|
                issues += 1
                notice += err + ". "
              end
            end
          end
        end
      end
    end
    {:added => added, :house_added => house_added, :issues => issues, :house_issues => house_issues, 
      :notice => notice, :success => success}
  end
  
  def self.set_local_title(local_title, channel)
    issues = 0
    added = 0
    notice = ''
    case channel.language.name
    when 'Danish'
      if @title.danish && (!(@title.danish.empty?))
        do_save = false
        if @title.danish != local_title
          issues = 1
          notice = 'Danish title different from stored. Original title: ' + @title.danish + ". New title: " + local_title + '. Original kept. '
        end
      else
        @title.danish = local_title
        added = 1
        do_save = true
      end
    when 'Swedish'
      if @title.swedish && (!(@title.swedish.empty?))
        do_save = false
        if @title.swedish != local_title
          issues = 1
          notice = 'Swedish title different from stored. Original title: ' + @title.swedish + ". New title: " + local_title + '. Original kept. '
        end
      else
        @title.swedish = local_title
        added = 1
        do_save = true
      end
    when 'Hungarian'
      if @title.hungarian && (!(@title.hungarian.empty?))
        do_save = false
        if @title.hungarian != local_title
          issues = 1
          notice = 'Hungarian title different from stored. Original title: ' + @title.hungarian + ". New title: " + local_title + '. Original kept.'
        end
      else
        @title.hungarian = local_title
        added =1
        do_save = true
      end
    when 'Norwegian'
      if @title.norwegian && (!(@title.norwegian.empty?))
        do_save = false
        if @title.norwegian != local_title
          issues = 1
          notice = 'Norwegian title different from stored. Original title: ' + @title.norwegian + ". New title: " + local_title + '. Original kept. '
        end
      else
        @title.norwegian = local_title
        added =1
        do_save = true
      end
    end
    {:added => added, :issues => issues, :notice => notice, :do_save => do_save}
  end
  
  def self.add_from_schedule_comparison(line)
    comparison = {
      :found => line.found?,
      :house_found => line.found_house,
      :house_number => line.house_number,
      :title => line.title,
      :original_title => line.original_title,
      :local_title => line.local_title,
      :series_number => line.series_number,
      :channel => line.channel
    }
    add_from_comparison comparison
  end
  
  def self.add_from_playlist_comparison(line)
    comparison = {
      :found => line.found?,
      :house_found => line.found_house,
      :house_number => line.house_no,
      :title => line.long_title,
      :original_title => line.original_title,
      :local_title => line.danish_title,
      :series_number => nil,
      :channel => line.channel
    }
    add_from_comparison comparison
  end
      
end
