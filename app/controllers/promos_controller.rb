class PromosController < ApplicationController
  # GET /promos
  # GET /promos.xml
  def index

    respond_to do |format|
      format.html { index_html(params) }
      format.xml { index_xml(params) }
    end
  end

  # GET /promos/1
  # GET /promos/1.xml
  def show
    @promo = Promo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @promo }
    end
  end

  # GET /promos/new
  # GET /promos/new.xml
  def new
    @promo = Promo.new_with_default_times
    @titles = Title.all
    @promo_types = PromoType.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @promo }
    end
  end

  # GET /promos/1/edit
  def edit
    @promo = Promo.find(params[:id])
    @titles = Title.all
    @promo_types = PromoType.all
  end

  # POST /promos
  # POST /promos.xml
  def create
    @promo = Promo.new(params[:promo])

    respond_to do |format|
      if @promo.save
        flash[:notice] = 'Promo Media was successfully created.'
        format.html { redirect_to(promos_path) }
        format.xml  { render :xml => @promo, :status => :created, :location => @promo }
      else
        @titles = Title.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @promo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /promos/1
  # PUT /promos/1.xml
  def update
    @promo = Promo.find(params[:id])

    respond_to do |format|
      if @promo.update_attributes(params[:promo])
        flash[:notice] = 'Promo Media was successfully updated.'
        format.html { redirect_to(promos_path) }
        format.xml  { head :ok }
      else
        @titles = Title.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @promo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /promos/1
  # DELETE /promos/1.xml
  def destroy
    @promo = Promo.find(params[:id])
    @promo.media_files.destroy_all
    @promo.destroy

    respond_to do |format|
      format.html { redirect_to(promos_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /promos/last_use
  def last_use
    @promos = Promo.past_last_use(params)
    
    respond_to do |format|
      format.html 
      format.xml { render :xml => @promo }
    end
  end
  
  def change_last_use
    if Useful.date?(params[:new_last_use])
      if params[:promo_ids] != nil
        added = 0
        media_added = 0
        params[:promo_ids].each do |id| 
          new_media_added = Promo.change_last_use_and_media (id, params[:new_last_use])
          if new_media_added 
            added += 1
            media_added += new_media_added
          end
        end
        flash[:notice] = 'Last use updated on ' + @template.pluralize(added, 'promo') if added > 0
        flash[:notice] += ' and ' + @template.pluralize(media_added, 'media file') if media_added > 0
      else
        flash[:notice] = "Nothing checked"
      end
    else
      flash[:notice] = "Invalid date"
    end
    redirect_to(promo_past_last_use_path)
  end
  
  def add_media
    
    @promo = Promo.find(params[:id])
    @media_file = MediaFile.create_media(@promo, params[:media_type])
    @folders = MediaFolder.all(:order => :name)
    @media_types = MediaType.all
    
    respond_to do |format|
      format.html {redirect_to @promo}
      format.xml  { render :xml => @countdown_ipp }
    end
  end
  
  protected
  
  def index_html(params)
    @promos = Promo.search(params[:search], params[:page])
  end
    
  def index_xml(params)
    if params[:last_use]
      @promos = Promo.filter_expired(params)
    else
      @promos = Promo.all
    end
    
  end
  
  
end
