xml.instruct! :xml, :version => "1.0"

  xml.press_lines do
    for press_line in @press_lines
      xml.item do
        xml.start press_line.start
        xml.display_title press_line.display_title
        xml.original_title press_line.original_title
        xml.lead_text press_line.lead_text
        if press_line.priority.nil?
          xml.priority false
        else
          xml.priority press_line.priority
        end
      end
    end
    
end

        
