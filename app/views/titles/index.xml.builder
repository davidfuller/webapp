xml.instruct! :xml, :version => "1.0"

xml.houses do
  for title in @titles
    xml.item do
      xml.title_id title.id
      xml.english title.schedule_title
      xml.danish title.display_title
      for house in title.houses
        xml.house_number house.house_number
      end
    end
  end    
end

        
