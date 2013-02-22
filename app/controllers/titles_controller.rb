class TitlesController < ApplicationController
  # GET /titles
  # GET /titles.xml
  def index
    
    respond_to do |format|
      format.html { index_html(params)}
      format.xml { @titles = Title.all(:include => :houses) } 
    end
  end

  # GET /titles/1
  # GET /titles/1.xml
  def show
    @title = Title.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @title }
    end
  end

  # GET /titles/new
  # GET /titles/new.xml
  def new
    @title = Title.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @title }
    end
  end
  
  def new_from_cross_channel
    press = PressLine.find(params[:id])
    language = Channel.find_by_name(params[:channel]).language
    if !(press.nil?) && !(language.nil?)
      @title = Title.find_by_english(press.original_title)
      if @title.nil? then
        @title = Title.new
        @title.english = press.original_title
        action = "new"
      else
        action = "edit"
      end
      set_local_title(press.display_title, language)  
      @title.source = params[:source] || "cross_channel"
      @title.channel = params[:channel] || ""
      @title.press_line_id = params[:id]|| nil
      render :action => action
    end  
  end

  def edit_from_manual_cross_channel
    language = Channel.find(params[:channel_id]).language
    if !(language.nil?)
      @title = Title.find(params[:id])
      if @title.nil? then
        @title = Title.new
        action = "new"
      else
        action = "edit"
      end
      @title.source = params[:source] || "cross_channel_manual"
      render :action => action
    end
  end
    

  def new_from_press
    @title = Title.new
    press = PressLine.find(params[:id])
    language = Channel.find_by_name(params[:channel]).language
    if !(press.nil?) && !(language.nil?)
      @title = Title.find_by_english(press.original_title)
      if @title.nil? then
        @title = Title.new
        @title.english = press.original_title
        set_local_title(press.display_title, language)  
        if params[:source]
          @title.source = params[:source]
        else
          @title.source = "Press"
        end
        if params[:channel]
          @title.channel = params[:channel]
        else
          @title.channel = ""
        end
        @title.schedule_comparison_id = params[:schedule_comparison_id]
        render :action => "new"
      else
        set_local_title(press.display_title, language)
        if params[:source]
          @title.source = params[:source]
        else
          @title.source = "Press"
        end
        if params[:channel]
          @title.channel = params[:channel]
        else
          @title.channel = ""
        end
        flash[:notice] = 'Title already in database. Editing details'
        render :action => "edit"
      end
    end
  end
    
    
  # GET /titles/1/edit
  def edit
    @title = Title.find(params[:id])
  end

  # POST /titles
  # POST /titles.xml
  def create
    @title = Title.new(params[:title])

    respond_to do |format|
      if @title.save
        flash[:notice] = 'Title was successfully created.'
        if @title.source == "Press"
          format.html { redirect_to press_lines_with_date(session[:press_date], @title.channel) }
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        elsif @title.source == "Schedule Comparison"
          format.html { ScheduleComparison.update_conditions(@title.schedule_comparison_id)
                        redirect_to schedule_comparison_path_with_filter_and_filename }
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        elsif @title.source == "Comparison"
          format.html { redirect_to comparison_path_with_filter_and_filename }
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        elsif @title.source == "cross_channel"
          format.html { redirect_to add_xchannel_priority(@title.press_line_id, @title.channel)}
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        elsif @title.source == "cross_channel_manual"
          format.html { redirect_to cross_channel_priorities_path }
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        else
          format.html { redirect_to titles_path_with_language }
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @title.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /titles/1
  # PUT /titles/1.xml
  def update
    @title = Title.find(params[:id])

    respond_to do |format|
      if @title.update_attributes(params[:title])
        flash[:notice] = 'Title was successfully updated.'
        if @title.source == "Press"
          format.html { redirect_to press_lines_with_date(session[:press_date], @title.channel) }
          format.xml  { head :ok }
        elsif @title.source == "cross_channel"
          format.html {redirect_to add_xchannel_priority(@title.press_line_id, @title.channel)}
          format.xml  { head :ok }
        elsif @title.source == "cross_channel_manual"
          format.html { redirect_to cross_channel_priorities_path }
          format.xml  { head :ok }
        else
          format.html { redirect_to titles_path_with_language }
          format.xml  { head :ok }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @title.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /titles/1
  # DELETE /titles/1.xml
  def destroy
    @title = Title.find(params[:id])
    @title.destroy

    respond_to do |format|
      format.html { redirect_to titles_path_with_language }
      format.xml  { head :ok }
    end
  end

private

def set_local_title(local_title, language)

  case language.name
  when 'Danish'
    @title.danish = local_title
  when 'Swedish'
    @title.swedish = local_title
  when 'Hungarian'
    @title.hungarian = local_title
  when 'Norwegian'
    @title.norwegian = local_title
  end
  
end  
  
def index_html(params)

    @titles = Title.search(params[:search], params[:page])
    @languages = Language.display

    @danish = display_language("Danish")
    @swedish = display_language("Swedish")
    @norwegian = display_language("Norwegian")
    @hungarian = display_language("Hungarian")   
    @show_house = params[:house_no]     

end
  
end
