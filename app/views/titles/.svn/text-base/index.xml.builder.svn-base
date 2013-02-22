xml.instruct! :xml, :version => "1.0"

xml.houses do
  for title in @titles
    xml.item do
      xml.title_id title.id
      xml.english title.english
      xml.danish title.danish
      xml.swedish title.swedish
      xml.norwegian title.norwegian
      xml.hungarian title.hungarian
      xml.eop title.eop_boolean
      for house in title.houses
        xml.house_number house.house_number
      end
    end
  end    
end

        
