class Channel < ActiveRecord::Base
  
  belongs_to :language
  has_many :press_lines
  has_many :bugs
  has_many :media_folders
  has_many :countdown_ipps
  has_many :schedule_files
  has_many :schedule_comparisons
  has_many :playlist_filenames
  has_many :comparisons
  has_many :cross_channel_priorities
  has_many :dynamic_specials
  
  validates_presence_of :name, :language_id
  default_scope :order => :name
  
  
  def self.display
    all(:select => :name).map{|m| m.name}
  end
  
  def hd_display
    if hd
      "HD"
    else
      "SD"
    end
  end
  
  def self.press_channel_from_filename(filename)
    @channels = find(:all, :order => :name)
    logger.debug filename.inspect
    channel_name = 'Please select'
    @channels.each do |c|
      l = c.press_code.length
      if l > 0
        if filename.include? c.press_code
          channel_name = c.name
        end
      end
    end
    channel_name
  end
  
  
  def self.filename (channel, press_date)
    week = press_date.strftime('%V')
    year = press_date.strftime('%G')
#    channel.press_code + "_" + year + "-" + ("%02d" % week) + "_tab.txt"
    channel.press_code + "_" + year + "-" + week + "_tab.txt"
  end
  
  def self.encodings
    ["ISO-8859-1","UTF-8","WINDOWS-1250","WINDOWS-1251","WINDOWS-1252"]
  end
  
  
end
