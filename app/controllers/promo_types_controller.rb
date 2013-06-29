class PromoTypesController < ApplicationController
  # GET /promo_types
  # GET /promo_types.xml
  def index
    @promo_types = PromoType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @promo_types }
    end
  end

  # GET /promo_types/1
  # GET /promo_types/1.xml
  def show
    @promo_type = PromoType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @promo_type }
    end
  end

  # GET /promo_types/new
  # GET /promo_types/new.xml
  def new
    @promo_type = PromoType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @promo_type }
    end
  end

  # GET /promo_types/1/edit
  def edit
    @promo_type = PromoType.find(params[:id])
  end

  # POST /promo_types
  # POST /promo_types.xml
  def create
    @promo_type = PromoType.new(params[:promo_type])

    respond_to do |format|
      if @promo_type.save
        flash[:notice] = 'Promo type was successfully created.'
        format.html { redirect_to(@promo_type) }
        format.xml  { render :xml => @promo_type, :status => :created, :location => @promo_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @promo_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /promo_types/1
  # PUT /promo_types/1.xml
  def update
    @promo_type = PromoType.find(params[:id])

    respond_to do |format|
      if @promo_type.update_attributes(params[:promo_type])
        flash[:notice] = 'Promo type was successfully updated.'
        format.html { redirect_to(@promo_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @promo_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /promo_types/1
  # DELETE /promo_types/1.xml
  def destroy
    @promo_type = PromoType.find(params[:id])
    @promo_type.destroy

    respond_to do |format|
      format.html { redirect_to(promo_types_url) }
      format.xml  { head :ok }
    end
  end
end
