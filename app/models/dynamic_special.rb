class DynamicSpecial < ActiveRecord::Base

  default_scope :order => 'channel_id, page'
  belongs_to :channel
  has_many :special_fields
  
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
  
  def next_field_number
    if special_fields.count > 0
      current_max = 0
      special_fields.each do |field|
        if field.number > current_max
          current_max =field.number
        end
      end
      current_max+1
    else
      1
    end
  end
  
  
end
