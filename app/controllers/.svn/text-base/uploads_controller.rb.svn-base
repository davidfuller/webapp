class UploadsController < ApplicationController
  
require 'net/http'  

  def index
    @channels = Channel.display
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def check_password
    if params[:password] == "clarity"
      redirect_to uploads_path
    else
      flash[:notice] = 'Incorrect password'
      redirect_to previews_path
    end
  end
  
  def upload_playlist
    if params[:playlist].nil?
      flash[:notice] = 'Please select a file'
      redirect_to uploads_path
    else
      uploaded_io = params[:playlist]
      filename = Rails.root.join('public','data', 'playlist', uploaded_io.original_filename)
    
      File.open(filename, 'w') do |file|
        file.write(Iconv.iconv("UTF-8",CHARSET_FORMAT,uploaded_io.read))
      end
    
      file = File.new(filename, "r")
      channel = PlaylistLine.get_channel(file, position_info)
      pl_filename = PlaylistFilename.find_or_create_by_filename(filename.to_s)
      pl_filename.channel = channel
      pl_filename.save
      logger.debug '==========>'
      logger.debug channel.name
    
      PlaylistLine.destroy_all(['playlist_filename_id = ?', pl_filename.id])
      file=File.new(filename, "r")
    
      part_no = 0
      house_no = "xxxxx"
      date_offset = 0
    
      while (line=file.gets)
        playlist = PlaylistLine.new
        playlist.playlist_filename_id = pl_filename.id
        playlist.addline(line, position_info, part_no, house_no, date_offset, pl_filename)
        part_no = playlist.part_no
        house_no = playlist.house_number
        date_offset = playlist.date_offset
      end
    
      redirect_to playlist_lines_path_with_filename(pl_filename.id)
    end
  end
  
  def upload_schedule
    if params[:schedule].nil?
      flash[:notice] = 'Please select a file'
      redirect_to uploads_path
    else
      uploaded_io = params[:schedule]
      filename = Rails.root.join('public','data', 'schedule', uploaded_io.original_filename)
      File.open(filename, 'w') do |file|
        file.write(Iconv.iconv("UTF-8",CHARSET_FORMAT,uploaded_io.read))
      end
    
      file = File.new(filename, "r")
      dates =ScheduleLine.get_start_stop_dates(file)
      channel =ScheduleLine.get_channel(file)
      ScheduleLine.delete_date_range(dates, channel)
      file_in_db = ScheduleFile.new_with_dates(filename, dates, channel)
    
      file = File.new(filename, "r")
      ScheduleLine.process_file(file, file_in_db)
    
      redirect_to schedule_line_path_with_filename(file_in_db)
    end
  end
  
  def web_upload_press_file
    channel = Channel.find_by_name(params[:channel]) 
    if channel.nil?
      flash[:notice] = "Invalid channel"
      redirect_to (uploads_path)   
    else
      begin
        filename = Channel.filename(channel,Date.parse(params[:press_date]))
      rescue
        filename = nil
      end
      
      if filename.nil?
          flash[:notice] = "Please enter a date"
          redirect_to (uploads_path)
      else
        local_filename = Rails.root.join('public','data', 'press', filename)

        Net::HTTP.start(channel.domain) do |http|
  #        resp = http.get("/press/cm/listings/" + filename)
          resp = http.get(channel.path + filename)
          File.open(local_filename, 'w') do |file|
#            file.write(Iconv.iconv("UTF-8//TRANSLIT//IGNORE", channel.encoding, resp.body))
            file.write(Iconv.iconv("UTF-8//IGNORE", channel.encoding, resp.body))
          end
        end
    
        begin
          process_press_file(local_filename,channel)
          redirect_to(press_lines_with_date(params[:press_date], params[:channel]))
        rescue Exception => exc
          logger.error "Error processing Press File #{exc.inspect}"
          flash[:notice] = "Unexpected error. It is possible the file is the wrong format"
          redirect_to(uploads_path)
        end
      end
    end
  end
  
  def process_press_file (filename,channel)
    
    base_filename = File.basename(filename)
    press_filename = PressFilename.find_or_create_by_filename(base_filename)
    press_filename.import_date = DateTime.now
    press_filename.save
    
    Priority.store_priority press_filename.id
    
    PressLine.destroy_all(['press_filename_id = ?', press_filename.id])

    file=File.new(filename, "r")
    last_time = Time.parse("00:01") #sets to a minute past midnight today
    line=file.gets

    while (line=file.gets)
      press = PressLine.new
      press.add_line(line, tab_info, last_time, channel, press_filename)
      last_time = press.last_start_time
    end
    
  end
  
  def upload_press_file
    uploaded_io = params[:press_file]
    channel = Channel.find_by_name(params[:channel])
    
    if channel.nil? 
      flash[:notice] = "Invalid channel"
      redirect_to(uploads_path)
    else

      begin
        filename = Rails.root.join('public','data', 'press', uploaded_io.original_filename)
      
        File.open(filename, 'w') do |file|
          file.write(Iconv.iconv("UTF-8//TRANSLIT//IGNORE", channel.encoding, uploaded_io.read))
        end

        process_press_file(filename,channel)
        redirect_to(press_lines_url)
      rescue NoMethodError
        flash[:notice] = "Invalid filename"
        redirect_to(uploads_path)
      rescue Exception => exc
        logger.error "Error processing Press File #{exc.inspect}"
        flash[:notice] = "Unexpected error. It is possible the file is the wrong format"
        redirect_to(uploads_path)
      end
      
    end
  end
  
  private
  def position_info
    event = PlaylistPositionSetting.find_by_item("Event No")
    start_date = PlaylistPositionSetting.find_by_item("Date")
    start_time = PlaylistPositionSetting.find_by_item("Time")
    duration = PlaylistPositionSetting.find_by_item("Duration")
    title = PlaylistPositionSetting.find_by_item("Title")
    source = PlaylistPositionSetting.find_by_item("Source")
    type = PlaylistPositionSetting.find_by_item("Material Type")
    material_id = PlaylistPositionSetting.find_by_item("Material ID")
    long_title = PlaylistPositionSetting.find_by_item("Long Title")
    timecode = PlaylistPositionSetting.find_by_item("Timecode")
    {:event => event, :title => title, :source => source,
              :start_date => start_date, :start_time => start_time, :duration => duration,
              :type => type, :material_id => material_id, :long_title => long_title, :timecode => timecode}
    
  end
  
  def tab_info
    start_date = PressTabSetting.find_by_item("Date")
    start_time = PressTabSetting.find_by_item("Time")
    display = PressTabSetting.find_by_item("Display Title")
    original = PressTabSetting.find_by_item("Original Title")
    lead_text = PressTabSetting.find_by_item("Lead Text")
    
    {:start_date => start_date, :start_time => start_time, :display => display, :original => original, 
      :lead_text => lead_text}
  end
  
  
end    

