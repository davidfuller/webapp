xml.instruct! :xml, :version => "1.0"

  xml.cross_channel_priorities do
    for priority in @cross_channel_priorities
      xml.item do
        xml.billed_time   priority.billed
        xml.channel_id    priority.channel_id
        xml.title_id      priority.title_id
        xml.lead_text     priority.lead_text
      end
    end
  
    
end

        
