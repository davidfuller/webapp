class MediaFile < ActiveRecord::Base

  belongs_to :media_folder
  has_and_belongs_to_many :countdown_ipps
  has_and_belongs_to_many :promos
  belongs_to :media_type
  belongs_to :status
  
  default_scope :order => 'first_use, media_type_id, filename'
  validates_uniqueness_of :filename, :message => " is already in the system"
  
  MAX_FOLDER_CLIPS = 400
  
  require 'useful'
  
  attr_accessor :source
  attr_accessor :promo_id
  attr_accessor :notice
  attr_accessor :issue
  
  def self.search(params)
    if params[:filename]
      find_all_by_filename(params[:filename])
    else
      type = MediaType.find_by_name(params[:media_type_display])
      if params[:search].nil? or params[:search].empty?
        if type
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['media_type_id = ?', type.id]       
        else
          paginate  :per_page => 12, :page =>params[:page]
        end
      else
        if type
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ? and media_type_id = ?', "%#{params[:search]}%", type.id]
        else
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ?', "%#{params[:search]}%"]
        end
      end
    end
  end 
  
  def self.unready
    ready = Status.find_by_message('Ready')
    find(:all, :conditions => ['status_id <> ?', ready.id ])
  end
  
  def first_promo_id
    if promos
      fp_id = promos.first.id
    else
      0
    end
  end
  
  def self.past_last_use(params)
    
    type = MediaType.find_by_name(params[:media_type_display])
    if type
      if Useful.date?(params[:last_use_date])
        last_use_date = Date.parse(params[:last_use_date]).strftime('%F')
        if params[:search]
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ? and DATE(last_use) <= ? and media_type_id =?', "%#{params[:search]}%", last_use_date, type.id]
        else
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['DATE(last_use) <= ? and media_type_id =?', last_use_date, type.id]
        end
      else
        if params[:search]
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ? and media_type_id =?', "%#{params[:search]}%", type.id]
        else
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => [media_type_id =?', type.id]
        end
      end
    else
      if Useful.date?(params[:last_use_date])
        last_use_date = Date.parse(params[:last_use_date]).strftime('%F')
        if params[:search]
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ? and DATE(last_use) <= ?', "%#{params[:search]}%", last_use_date]
        else
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['DATE(last_use) <= ?', last_use_date]
        end
      else
        if params[:search]
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ?', "%#{params[:search]}%"]
        else
          paginate  :all, :per_page => 12, :page =>params[:page]
        end
      end
    end
      
  end
  
  
  def self.update_all_to_countdown_ipp
    type = MediaType.find_by_name('Countdown IPP')
    all.each do |m|
      if !m.media_type then
        m.media_type = type
        m.save
      end
    end
  end
  
  def self.add_countdown_ipp(countdown_ipp)
    num_days = (countdown_ipp.last_use.to_i - countdown_ipp.first_use.to_i)/86400.to_i

    if num_days > 0
      countdown_ipp.media_files.destroy_all
      n = num_days
      aspects=[]
      aspects << Aspect.find_by_name("4x3 SD")
      aspects << Aspect.find_by_name("16x9 SD")
      
      while n >= 0
        aspects.each do |asp|
          logger.debug '======<>'
          logger.debug asp.file_suffix
          file = MediaFile.new
          file.name = create_name(countdown_ipp.name, n)
          file.filename = create_filename(file.name, countdown_ipp.first_use, '.cel', asp.file_suffix)
          file.first_use = file_first_use(countdown_ipp.first_use, n, num_days)
          file.last_use = file_last_use(countdown_ipp.first_use, countdown_ipp.last_use, n, num_days)
          file.media_folder = MediaFolder.find_by_name_and_channel('Countdown IPP', countdown_ipp.channel)
          file.media_type = MediaType.find_by_name('Countdown IPP')
          if file.save
            countdown_ipp.add_file file
          end
        end
        n -= 1
      end
    end
  end

  def status_display
    if status
      status.message
    else
      ''
    end
  end
          
  def quicktime_filename
    File.basename(filename, ".*") + ".mov"
  end
    
  def targa_filename
    File.basename(filename, ".*") + ".tga"
  end
  
  def jpeg_filename
    File.basename(filename, ".*") + ".jpg"
  end
  
  def self.update_2012
    folder_2012 = MediaFolder.find_by_name('Promo Clip 2012')
    if folder_2012
      mfs = find_all_by_media_folder_id(MediaFolder.find_by_name('Promo Clip'))
      converted = 0
      mfs.each do |mf|
        if mf.filename.length > 2 && mf.filename[0..1] == '12'
          mf.media_folder = folder_2012
          if mf.save
            converted +=1
          end
        end
      end
      converted
    else
      'Missing media folder Promo Clip 2012'
    end
  end
  
  def self.create_media(promo, type)

      file = MediaFile.new
      file.name = promo.name
      
      file.first_use = promo.first_use
      file.last_use = promo.last_use
      file.status = Status.find_by_value(0)
      
      case type
      when 'clip'
        file.filename = create_filename(file.name, promo.first_use, '.ppv',"")
        year_no = Useful.year_number(promo.first_use)
        if year_no.to_i >= 2012
          media_f = MediaFolder.find_by_name('Promo Clip ' + year_no)
          if media_f
            if overflow(media_f)
              media_f = MediaFolder.find_by_name('Promo Clip Overflow')
              if !media_f
                media_f=MediaFolder.find_by_name('Promo Clip')
              end
            end
            file.media_folder = media_f
          else
            file.media_folder = MediaFolder.find_by_name('Promo Clip')
          end
        else
          file.media_folder = MediaFolder.find_by_name('Promo Clip')
        end
        file.media_type = MediaType.find_by_name('Promo Clip')
      when 'still'
        file.filename = create_filename(file.name, promo.first_use, '.tga',"")
        file.media_folder = MediaFolder.find_by_name('Promo Still')
        file.media_type = MediaType.find_by_name('Promo Still')
      end
      
      if file.save
        promo.add_file file
      end
      file
  end
  
  def self.create_name(name, days)
    name + " " + "%02d" % days
  end
  
  def self.create_filename(name, first_use, extension, aspect)
    
    if aspect.nil? then
      aspect=""
    end

    n = Useful.filename_year_week(first_use)  + '_' + Useful.strip_filename(name).upcase + aspect + extension
    i = 0
    while find_by_filename(n)
      i+=1
      n = Useful.filename_year_week(first_use)  + '_' + Useful.strip_filename(name).upcase + aspect + "_" + "%02d" % i + extension
    end
    n
  end
  
  def self.file_first_use(first_use, day, num_days)
    first_use.advance(:days => (num_days-day))
  end  
  
  def self.file_last_use(first_use, last_use, day, num_days)
    
    file_last = first_use.advance(:days => (num_days-day + 1))
    if file_last > last_use
      last_use
    else
      file_last
    end    
  end  
  
  def self.upload(params)
    media = find(params[:id])
    do_it = false

    if media
      upload_file = params[:file]
      media.issue = false
      case media.media_type.name
      when 'Promo Clip'
        if upload_file.content_type == 'video/quicktime'
          media_folder_name = media.media_folder.name
          case media_folder_name
          when 'Promo Clip'
            filename = Rails.root.join('public','data', 'clip', media.quicktime_filename)
          when 'Promo Clip Overflow'
            filename = Rails.root.join('public','data', 'clip', 'Overflow', media.quicktime_filename)
          else
            year_string = media_folder_name[11,4]
            if year_string.to_i >0
              filename = Rails.root.join('public','data', 'clip', year_string, media.quicktime_filename)
            else
              filename = Rails.root.join('public','data', 'clip', media.quicktime_filename)
            end
          end
          do_it = true
        else
          media.notice = "Invalid file type. Expected: video/quicktime. Uploaded: " + upload_file.content_type
          media.issue = true
          do_it = false
        end
      when 'Promo Still'
        case upload_file.content_type 
        when 'image/targa', 'image/x-targa', 'application/octet-stream'
          filename = Rails.root.join('public','data', 'still', media.targa_filename)
          do_it = true
        else
          media.notice = "Invalid file type. Expected: image/targa. Uploaded: " + upload_file.content_type
          media.issue = true
          do_it = false
        end
      else
        media.notice = "The system currently cannot upload this kind of file"
        do_it = false
        media.issue = true
      end
      
      if do_it
		create_folder_if_not_exist(filename)
        File.open(filename, 'wb') do |file|
          file.write(upload_file.read)
        end
        media.notice = upload_file.original_filename + " uploaded. Content type: " + upload_file.content_type
        media.status = Status.find_by_message('Queued')
      end
    end
    media.save
    media
  end
  
  def clip_jpeg_proxy_folder
    Rails.root.join('public','data', 'proxies', 'clip', 'jpeg')
  end

  def clip_quicktime_proxy_folder
    Rails.root.join('public','data', 'proxies', 'clip', 'movs')
  end

  def still_jpeg_proxy_folder
    Rails.root.join('public','data', 'proxies', 'still')
  end
  
  def clip_jpeg_proxy_path
    "/data/proxies/clip/jpeg/"
  end
  
  def clip_jpeg_url
    clip_jpeg_proxy_path + jpeg_filename
  end
  
  def clip_quicktime_proxy_path
    "/data/proxies/clip/movs/"
  end
  
  def clip_jpeg_url
    clip_jpeg_proxy_path + jpeg_filename
  end
  
  def clip_quicktime_url
    clip_quicktime_proxy_path + quicktime_filename
  end
  
  def still_jpeg_proxy_path
    "/data/proxies/still/"
  end
  
  def still_jpeg_url
    still_jpeg_proxy_path + jpeg_filename
  end
  
  def jpeg_url
    case media_type.name
    when 'Promo Clip'
      clip_jpeg_url
    when 'Promo Still'
      still_jpeg_url
    else
      ""
    end
  end
  
  def jpeg_exist?
    case media_type.name
    when 'Promo Clip'
      File.exist?(clip_jpeg_proxy_folder.join(jpeg_filename))
    when 'Promo Still'
      File.exist?(still_jpeg_proxy_folder.join(jpeg_filename))
    else
      false
    end
  end
  
  def quicktime_exist?
    case media_type.name
    when 'Promo Clip'
      File.exist?(clip_quicktime_proxy_folder.join(quicktime_filename))
    else
      false
    end
  end
  
  def status_css
    if status
      case status.value
      when -1
        'error'
      when 0
        'not_loaded'
      when 1
        'waiting'
      when 2..10
        'processing'
      when 11
        'ready'
      end
    end
  end

  def self.change_last_use(id, new_last_use)
    m = find(id)
    m.last_use = new_last_use
    if m.save
      return true
    else
      return false
    end
  end

  def self.overflow(media_f)
    number_in_folder = find(:all, :conditions => ['media_folder_id = ?' ,media_f]).size
    if number_in_folder
      return number_in_folder > MAX_FOLDER_CLIPS
    else
      return false
    end
  end
 
  def self.create_folder_if_not_exist(filename)
    dirname = File.dirname(filename)
    Dir.mkdir(dirname) unless File.directory?(dirname)
  end

  
end
