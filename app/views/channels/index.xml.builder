xml.instruct! :xml, :version => "1.0"

  xml.channels do
    for channel in @channels
      xml.item do                                                             
        xml.id              channel.id                                        
        xml.name            channel.name                                      
        xml.format          channel.code                              
      end
    end
end

        
