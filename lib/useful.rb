module Useful


  def Useful.select_date_to_date (form_date)
    Date.new(form_date[:"start_date(1i)"].to_i, form_date[:"start_date(2i)"].to_i, form_date[:"start_date(3i)"].to_i)
  end 
  
  def self.replace_plus(name)
    name.gsub("+","_PLUS")
  end
  
  def Useful.strip_filename(name)
    name.gsub(/[^\w\.]/, '_').squeeze('__')
  end
  
  def Useful.week_number(date)
    if date.nil?
      ""
    else
      DateTime.parse(date.to_s).strftime('%V')
      # This is for windows, which didn't interpret a date string as a date
      # For mac it needed the date.to_s to work
    end
  end
  
  def Useful.year_number(date, digits = 4)
    if date.nil?
      ""
    else
      year = DateTime.parse(date.to_s).strftime('%G')
      # This is for windows, which didn't interpret a date string as a date
      # For mac it needed the date.to_s to work
      case digits
      when 2
        year[2,2]
      else
        year
      end
    end
  end
  
  def Useful.filename_year_week(date)
    if date
      year_number(date,2) + week_number(date)
    else
      ""
    end
  end
  
  def self.date?(date)
    d = Date.parse(date) rescue nil
    if d
      return true
    else
      return false
    end
  end
end