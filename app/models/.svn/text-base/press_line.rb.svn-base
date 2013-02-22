class PressLine < ActiveRecord::Base
  
  belongs_to :channel
  belongs_to :press_filename
  validates_presence_of :channel_id, :press_filename_id
  
  def self.search(search, press_date, channel_name)

    channel = get_channel(channel_name)
    
    if search
      if press_date.blank?
        find(:all, :conditions => ['original_title LIKE ? and channel_id = ?', "%#{search}%", channel.id], :order => :start)
      else
        date = Date.parse(press_date).strftime('%F')
        find(:all, :conditions => ['original_title LIKE ? and DATE(start) = ? and channel_id = ?', "%#{search}%", date, channel.id], :order => :start)
      end
    else
      if press_date.blank?
        find(:all, :conditions => ['channel_id = ?', channel.id], :order => :start)
      else
        date = Date.parse(press_date).strftime('%F')
        find(:all, :conditions => ['DATE(start) = ? and channel_id = ?', date, channel.id], :order => :start)
      end
    end
  end 
  
  def self.find_by_start_and_channel(start, channel)
    
    find(:first, :conditions => ['start = ? and channel_id =?',start,channel.id])
    
  end
  
  
  def self.priority_and_lead(params)
    channel = get_channel(params[:channel])
    start_date = Date.parse(params[:priority_date]).strftime('%F')
    end_date = (Date.parse(params[:priority_date]) + params[:days].to_i.days).strftime('%F')
#    find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ?  and (priority = ? or LENGTH(lead_text) > 0)', start_date, end_date, channel.id, true], :order => :start)
    find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ? ', start_date, end_date, channel.id], :order => :start)
  end
  
  def self.priority_lines(show, priority_date, channel_name)
    
    channel = get_channel(channel_name)
    
    if priority_date.blank?
      date = Time.new("00:00:00") # midnight today
    else
      date = Date.parse(priority_date)
    end
    
    end_date = date + 6.days
    
    if show == 'Priority Only'
      find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ? and priority = ?',
                                  date.strftime('%F'), end_date.strftime('%F'), channel.id, true], :order => :start)
    elsif show == 'All'
      find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ?',
                                date.strftime('%F'), end_date.strftime('%F'), channel.id], :order => :start)
    else
      find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ? and TIME(start) >= ?',
                                date.strftime('%F'), end_date.strftime('%F'), channel.id, "17:00:00"], :order => :start)
    end

  end
  
  def self.get_channel(channel_name)
    channel = Channel.find_by_name(channel_name)
    if channel.nil?
      channel = Channel.first
    end
    channel
  end
  
  
  def add_line(line, tab, last, channel, filename)
      element = line.split("\t")
      press = PressLine.new

      start_date = element[tab[:start_date].position-1]
      start_time = element[tab[:start_time].position-1]
      if start_date.empty?
        start_date = last.strftime("%Y-%m-%d")
        @start = increment_date(start_date_time(start_date, start_time), last)
      else
        @start = start_date_time(start_date, start_time)
      end
      
      press.start = @start
      press.display_title = element[tab[:display].position - 1].strip
      press.original_title = element[tab[:original].position - 1].strip
      press.channel = channel
      press.press_filename = filename
      press.lead_text = element[tab[:lead_text].position - 1].strip
      press.priority = Priority.priority(filename.id, @start)
      press.save
  end
  
  def channel_name
    if channel.nil?
      ""
    else
      channel.name
    end
  end
  
  def priority_display
    if priority
      'Priority'
    else
      ''
    end
  end
  
  def last_start_time
    @start
  end
  
  def date_offset
    @date_offset
  end
  
  def self.unique_dates
    press = find(:all, :order => :start)
    unique=[]
    last_date_part=DateTime.now
    press.each do |p|
      if not p.start.nil?
        current = p.start_date_part
        if last_date_part != current
          unique << current 
          last_date_part = current
        end
      end
    end
    unique
  end
  
  def start_date_part
    date_part(self.start)
  end
  
  private
  def start_date_time (start_date, start_time)
    # Expects start_date to be a string in the format yyyy-mm-dd
    # Expects start_time to be a string in the format hh:mm:ss:ff
    DateTime.strptime(start_date+start_time,"%Y-%m-%d%H:%M") 
    
  rescue ArgumentError
    nil
  end
  
  
  def increment_date(current, last)
    if current.hour<10 and last.hour>10
      current + 1.days
    else
      current
    end
  end
  
  
  def date_part(t)
    DateTime.new(t.year,t.month,t.day)
  end
  
  
end
