xml.instruct! :xml, :version => "1.0"

  xml.promos do
    for promo in @promos
      xml.item do
        xml.id promo.id
        xml.name promo.name
        xml.description promo.description
        xml.title_id promo.title_id
        xml.english promo.title.english unless promo.title.nil?
        xml.first_use promo.first_use
        xml.last_use promo.last_use
        promo.media_files.each do |media_file|
          xml.media_file do
            xml.name  media_file.name
            xml.filename  media_file.filename
            xml.folder media_file.media_folder.folder unless media_file.media_folder.nil?
            xml.first_use media_file.first_use
            xml.last_use media_file.last_use
            xml.status media_file.status.message unless media_file.status.nil?
            xml.media_type media_file.media_type.name unless media_file.media_type.nil?
            xml.media_id media_file.id
          end
        end
      end
    end
    
end

        
