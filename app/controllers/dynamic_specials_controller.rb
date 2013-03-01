class DynamicSpecialsController < ApplicationController
  # GET /dynamic_specials
  # GET /dynamic_specials.xml
  def index
    @dynamic_specials = DynamicSpecial.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dynamic_specials }
    end
  end

  # GET /dynamic_specials/1
  # GET /dynamic_specials/1.xml
  def show
    @dynamic_special = DynamicSpecial.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dynamic_special }
    end
  end

  # GET /dynamic_specials/new
  # GET /dynamic_specials/new.xml
  def new
    @dynamic_special = DynamicSpecial.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dynamic_special }
    end
  end

  # GET /dynamic_specials/1/edit
  def edit
    @dynamic_special = DynamicSpecial.find(params[:id])
  end

  # POST /dynamic_specials
  # POST /dynamic_specials.xml
  def create
    @dynamic_special = DynamicSpecial.new(params[:dynamic_special])

    respond_to do |format|
      if @dynamic_special.save
        flash[:notice] = 'DynamicSpecial was successfully created.'
        format.html { redirect_to(@dynamic_special) }
        format.xml  { render :xml => @dynamic_special, :status => :created, :location => @dynamic_special }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dynamic_special.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dynamic_specials/1
  # PUT /dynamic_specials/1.xml
  def update
    @dynamic_special = DynamicSpecial.find(params[:id])

    respond_to do |format|
      if @dynamic_special.update_attributes(params[:dynamic_special])
        flash[:notice] = 'DynamicSpecial was successfully updated.'
        format.html { redirect_to(@dynamic_special) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dynamic_special.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dynamic_specials/1
  # DELETE /dynamic_specials/1.xml
  def destroy
    @dynamic_special = DynamicSpecial.find(params[:id])
    @dynamic_special.destroy

    respond_to do |format|
      format.html { redirect_to(dynamic_specials_url) }
      format.xml  { head :ok }
    end
  end
end
