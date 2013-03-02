class DynamicSpecial < ActiveRecord::Base

  default_scope :order => 'channel_id, page'
  belongs_to :channel
  
  validates_presence_of :name, :page, :channel_id
  
  def self.search(channel)
    channel_id = Channel.find_by_name(channel)
    if channel_id
      find_all_by_channel_id(channel_id)
    else
      all
    end
  end
  
  def channel_name
    if channel
      channel.name
    else
      ''
    end
  end
  
end
