# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

#  CHARSET_FORMAT = "ISO-8859-1"
   CHARSET_FORMAT = "WINDOWS-1252"
#    CHARSET_FORMAT = "UTF-8"
 
# THIS IS THE SKY VERSION   
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def format_date_time(value, format)
    if value.nil? then
      ""
    else
      value.strftime(format)
    end
  end
  
  
  def titles_path_with_language
    {:controller => :titles, :action => :index, :language => session[:language]}
  end
  
  def playlist_lines_path_with_show
    {:controller => :playlist_lines, :action => :index, :show => session[:show]}
  end

  def playlist_lines_path_with_show_and_filename
    {:controller => :playlist_lines, :action => :index, :show => session[:show], :filename => session[:filename]}
  end
  
  def playlist_lines_path_with_filename(filename_id)
    {:controller => :playlist_lines, :action => :index, :show => session[:show], :filename => filename_id.to_s}
  end

  def comparison_path_with_filter
    {:controller => :comparisons, :action => :index, :show => session[:show_comparison]}
  end
  
  def comparison_path_with_filter_and_filename
    {:controller => :comparisons, :action => :index, :show => session[:show_comparison], :filename => session[:filename]}
  end
  
  def comparison_path_with_last_filename
    filename = PlaylistFilename.last_entered
    if filename
      {:controller => :comparisons, :action => :index, :show => session[:show_comparison], :filename => filename.id.to_s}
    else
      {:controller => :comparisons, :action => :index, :show => session[:show_comparison]}
    end
  end
  
  def schedule_comparison_path_with_filter_and_filename
    if session[:schedule_comparison_filename]
      {:controller => :schedule_comparisons, :action => :index, :show => session[:show_schedule_comparison], 
          :schedule_filename => session[:schedule_comparison_filename] }
    else
      schedule_comparison_path_with_last_filename
    end
  end

  def schedule_comparison_path_with_filter(filename_id)  
    if filename_id
      {:controller => :schedule_comparisons, :action => :index, :show => session[:show_schedule_comparison], 
          :schedule_filename => filename_id }
    else
      schedule_comparison_path_with_last_filename
    end
  end
  
  
  def schedule_comparison_path_with_last_filename
    filename = ScheduleFile.last_entered
    if filename
      {:controller => :schedule_comparisons, :action => :index, :show => session[:show_schedule_comparison],
                      :schedule_filename => filename.id.to_s}
    else
      {:controller => :schedule_comparisons, :action => :index, :show => session[:show_schedule_comparison]}
    end
  end
  
  def schedule_line_path_with_filename(filename)
    if filename then
      {:controller => :schedule_lines, :action => :index, :schedule_filename => filename.id.to_s}
    else
      schedule_line_path_with_last_filename
    end
  end
  
  def schedule_line_path_with_last_filename
    filename = ScheduleFile.last_entered
    if filename
      {:controller => :schedule_lines, :action => :index, :schedule_filename => filename.id.to_s}
    else
      {:controller => :schedule_lines, :action => :index}
    end
  end
  
  def jpeg_with_folder(folder)
    {:controller => :jpegs, :action => :index, :folder => folder.id.to_s}
  end
  
  def preview_jpeg_with_folder(folder)
    {:controller => :preview_jpegs, :action => :index, :folder => folder.id.to_s}
  end
  
  def jpeg_with_session_folder_and_search
    {:controller => :jpegs, :action => :index, :folder => session[:jpeg_folder], :search => session[:jpeg_search]}
  end
  
  def preview_jpeg_with_session_folder_and_search
    {:controller => :preview_jpegs, :action => :index, :folder => session[:jpeg_folder], :search => session[:jpeg_search]}
  end
  
  def press_lines_with_date(date, channel_name)
    if not date
      date=format_date_time(Date.today,"%B %e, %Y")
    end
    if channel_name.blank?
      channel_name = session[:press_channel]
    end
    {:controller => :press_lines, :action => :index, :search => '', :press_date => date, 
      :channel => channel_name}
  end
  
  def priority_with_date(date, channel_name, show)
    if date.nil?
      date = format_date_time(Date.today,"%B %e, %Y")
    end
    if channel_name.blank?
      channel_name = session[:priority_channel]
    end
    if show.blank?
      show = session[:priority_show]||'Peak'
    end
    {:controller => :press_lines, :action => :priority, :priority_date => date, 
      :channel => channel_name, :show => show}
  end
  
  def display_language(language)
    (params[:language].nil?) | (params[:language] == 'All') | (params[:language] == language)
  end
  
  def media_files_path_with_type
    {:controller => :media_files, :action => :index, :media_type_display => session[:media_type_display]}
  end

  def media_files_unready_path
    {:controller => :media_files, :action => :unready }
  end
  
  def promo_past_last_use_path (date = nil)
    if not date
      date=format_date_time(Date.today,"%B %e, %Y")
    end
    {:controller => :promos, :action => :last_use, :last_use_date => date}
  end
  
  def media_files_past_last_use_path (date = nil)
    if not date
      date=format_date_time(Date.today,"%B %e, %Y")
    end
    {:controller => :media_files, :action => :last_use, :last_use_date => date, 
      :media_type_display => session[:last_use_media_type_display]}
  end
  
  def xchannel_press_lines_path
    {:controller => :press_lines, :action => :cross_channel_selection, 
     :search => params[:search], :press_date => params[:press_date], 
     :channel => params[:channel_name], :cross_tx_channel => params[:cross_tx_channel],
     :cross_priority_date => params[:cross_priority_date]}
    
  end
  
  def cross_channel_priorities_with_date(press_date, tx_date)
    
    if not press_date
      press_date = format_date_time(Date.today,"%B %e, %Y")
    end
    if not tx_date
      tx_date = press_date
    end
    
    channel_name = session[:xchannel_press_channel]
    tx_channel_name = session[:cross_tx_channel]
    search = session[:cross_press_search] 
    cross_search = session[:cross_search] 
    
    {:controller => :cross_channel_priorities, :action => :index, 
      :search => search, :cross_search => cross_search,
      :press_date => press_date, :channel => channel_name, 
      :cross_tx_channel => tx_channel_name, :cross_priority_date => tx_date}
  end
  
  def add_xchannel_priority(press_line, cross_tx_channel)
    {:controller => :cross_channel_priorities, :action => :xchannel_priority, 
		 :id => press_line, :cross_tx_channel => cross_tx_channel}
	end
	
	def add_title_from_cross(press_line, cross_tx_channel)
	  { :controller => :titles, :action => :new_from_cross_channel, 
		  :id => press_line, :source => 'cross_channel', 
		  :channel => cross_tx_channel}
	end
	
  def edit_title_from_manual_cross_channel(title_id, channel_id)
    { :controller => :titles, :action => :edit_from_manual_cross_channel, 
      :id => title_id, :source => 'cross_channel_manual', 
      :channel_id => channel_id}
  end
    
  
  helper_method :titles_path_with_language, :playlist_lines_path_with_show, :comparison_path_with_filter, 
                :playlist_lines_path_with_show_and_filename, :comparison_path_with_filter_and_filename,
                :comparison_path_with_last_filename, :jpeg_with_folder, :press_lines_with_date,
                :format_date_time, :schedule_comparison_path_with_last_filename, 
                :schedule_comparison_path_with_filter_and_filename, :schedule_line_path_with_last_filename,
                :preview_jpeg_with_folder, :priority_with_date, :media_files_path_with_type,
                :schedule_line_path_with_filename, :media_files_unready_path,
                :schedule_comparison_path_with_filter, :jpeg_with_session_folder_and_search,
                :preview_jpeg_with_session_folder_and_search, :promo_past_last_use_path, 
                :media_files_past_last_use_path, :xchannel_press_lines_path, :cross_channel_priorities_with_date,
                :add_xchannel_priority, :add_title_from_cross, :edit_title_from_manual_cross_channel
  
end
