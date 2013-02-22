class MediaFilesController < ApplicationController
  # GET /media_files
  # GET /media_files.xml
  def index
    @media_files = MediaFile.search(params)
    @media_type_display = MediaType.media_type_display
    @statuses = Status.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  #_{ render :xml => @media_files }
    end
  end

  # GET /media_files/1
  # GET /media_files/1.xml
  def show
    @media_file = MediaFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @media_file }
    end
  end

  # GET /media_files/new
  # GET /media_files/new.xml
  def new
    @media_file = MediaFile.new
    @folders = MediaFolder.all(:order => :name)
    @media_types = MediaType.all
    @statuses = Status.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @media_file }
    end
  end

  # GET /media_files/1/edit
  def edit
    @media_file = MediaFile.find(params[:id])
    @media_file.source = params[:source]
    @media_file.promo_id = params[:promo_id]
    @folders = MediaFolder.all(:order => :name)
    @media_types = MediaType.all
    @titles = Title.all
    @statuses = Status.all
  end

  # POST /media_files
  # POST /media_files.xml
  def create
    @media_file = MediaFile.new(params[:media_file])
    
    respond_to do |format|
      if @media_file.save
        flash[:notice] = 'Media File was successfully created.'
        format.html { redirect_to(media_files_path_with_type) }
        format.xml  { render :xml => @media_file, :status => :created, :location => @media_file }
      else
        @folders = MediaFolder.all(:order => :name)
        @media_types = MediaType.all
        @titles = Title.all
        @statuses = Status.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @media_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /media_files/1
  # PUT /media_files/1.xml
  def update
    @media_file = MediaFile.find(params[:id])

    respond_to do |format|
      if @media_file.update_attributes(params[:media_file])
        flash[:notice] = 'Media File was successfully updated.'

        if @media_file.source == 'promo'
          format.html { redirect_to(promo_path(@media_file.promo_id)) }
          format.xml  { head :ok }
        elsif @media_file.source == 'promo index'
          format.html { redirect_to(promos_path) }
          format.xml  { head :ok }
        else
          format.html { redirect_to(media_files_path_with_type) }
          format.xml  { head :ok }
        end
      else
        @folders = MediaFolder.all(:order => :name)
        @media_types = MediaType.all
        @titles = Title.all
        @statuses = Status.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @media_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /media_files/1
  # DELETE /media_files/1.xml
  def destroy
    @media_file = MediaFile.find(params[:id])
    @media_file.destroy

    respond_to do |format|
      if params[:source] == 'promo'
        format.html { redirect_to(promo_path(params[:promo_id])) }
        format.xml  { head :ok }
      elsif params[:source] == 'promo index'
        format.html { redirect_to(promos_path) }
        format.xml  { head :ok }        
      else
        format.html { redirect_to(media_files_path_with_type) }
        format.xml  { head :ok }
      end
    end
  end
  
  def upload_file
    if params[:file].nil?
      flash[:notice] = 'Please select a file'
      redirect_to(:back)
    else
      @media_file = MediaFile.upload(params)
      flash[:notice] = @media_file.notice
      if @media_file.issue
        redirect_to :back
      elsif params[:source] == 'promo'
        @promo = Promo.find(@media_file.first_promo_id)
        redirect_to @promo
      elsif params[:source] == 'promo index'
        redirect_to promos_path (:details => true)
      else
        redirect_to media_file_path(@media_file, :source => params[:source])
      end
    end
  end
  
  def unready
    @media_files = MediaFile.unready
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  #_{ render :xml => @media_files }
    end
  end
  
  # GET /media_files/last_use
  def last_use
    if params[:media_type_display].nil?
      params[:media_type_display] = 'Promo Clip'
    end
    @media_files = MediaFile.past_last_use(params)
    @media_type_display = MediaType.clips_and_stills
    
    respond_to do |format|
      format.html 
      format.xml { render :xml => @media_files }
    end
  end
  
  def change_last_use
    if Useful.date?(params[:new_last_use])
      if params[:media_file_ids] != nil
        added = 0
        params[:media_file_ids].each do |id| 
          if MediaFile.change_last_use(id, params[:new_last_use])
            added += 1
          end
        end
        flash[:notice] = 'Last use updated on ' + @template.pluralize(added, 'media file') if added > 0
      else
        flash[:notice] = "Nothing checked"
      end
    else
      flash[:notice] = "Invalid date"
    end
    redirect_to(media_files_past_last_use_path)
  end
end
