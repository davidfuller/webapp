class Priority < ActiveRecord::Base
  
  FILTERS = [
    {:label => "All",                    :position => 0},
    {:label => "Peak",                   :position => 1},
    {:label => "Priority Only",          :position => 2}
   ]

   def self.filter_display
     filters = []
     FILTERS.each do |filter|
       filters << [filter[:label]]
     end
     filters
   end

  
  
def self.store_priority(press_filename_id)  
  
    destroy_all(['press_filename_id = ?', press_filename_id])
    press = PressLine.find_all_by_press_filename_id(press_filename_id)
    if press
      press.each do |line|
        if line.priority
          p = Priority.new
          p.press_filename_id = press_filename_id
          p.start = line.start
          p.save
        end
      end
    end
          
end
  

def self.priority(press_filename_id, start)
  
  p = find_by_press_filename_id_and_start(press_filename_id, start)
  if p 
    true
  else
    false
  end
end

  
  
  
  
  
end
