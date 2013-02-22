class HousesController < ApplicationController
  
  # GET /houses
  # GET /houses.xml
  def index
  
    respond_to do |format|
      format.html { @houses = House.search(params[:search], params[:page]) }
      format.xml { @houses = House.all }
    end
  end

  # GET /houses/1
  # GET /houses/1.xml
  def show
    @house = House.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @house }
    end
  end

  # GET /houses/new
  # GET /houses/new.xml
  def new
    @house = House.new
    @titles = Title.all
    @series_numbers = SeriesNumber.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @house }
    end
  end
  
  def new_from_comparison
    @titles = Title.all
    @series_numbers = SeriesNumber.all
    comp = Comparison.find(params[:id])
    if not comp.nil?
      @house = House.find_by_house_number(comp.house_no)
      if @house.nil? then
        flash[:notice] = comp.long_title
        @house = House.new
        @house.house_number = comp.house_no
        @house.source = 'comparison'
        render :action => "new"
      else
        flash[:notice] = 'House number already in database. You can edit details if you wish'
        @house.source = 'comparison'
        render :action => "edit"
      end
    end
  end
  
  def new_from_schedule_comparison
    @titles = Title.all
    @series_numbers = SeriesNumber.all
    comp = ScheduleComparison.find(params[:id])
    if not comp.nil?
      @house = House.find_by_house_number(comp.house_number)
      if @house.nil? then
        flash[:notice] = comp.title
        @house = House.new
        @house.house_number = comp.house_number
        s = SeriesNumber.find_or_create_by_series_number(comp.series_number)
        if s
          @house.series_number = s
        end if
        @house.source = 'schedule comparison'
        @house.schedule_comparison = comp.id
        render :action => "new"
      else
        flash[:notice] = 'House number already in database. You can edit details if you wish'
        @house.source = 'schedule comparison'
        render :action => "edit"
      end
    end  
  end
  
    
  # GET /houses/1/edit
  def edit
    @house = House.find(params[:id])
    @titles = Title.all 
    @series_numbers = SeriesNumber.all
  end

  # POST /houses
  # POST /houses.xml
  def create
    @house = House.new(params[:house])

    respond_to do |format|
      if @house.save
        flash[:notice] = 'House number was successfully created. '
        format.html { 
          if @house.source == 'comparison'
            redirect_to comparison_path_with_filter_and_filename
          elsif @house.source == 'schedule comparison'
            ScheduleComparison.update_conditions(@house.schedule_comparison)
            redirect_to schedule_comparison_path_with_filter_and_filename
          else  
            redirect_to houses_path
          end
          }
        format.xml  { render :xml => @house, :status => :created, :location => @house }
      else
        @titles = Title.all 
        @series_numbers = SeriesNumber.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @house.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /houses/1
  # PUT /houses/1.xml
  def update
    @house = House.find(params[:id])

    respond_to do |format|
      if @house.update_attributes(params[:house])
        flash[:notice] = 'House number was successfully updated.'
        format.html { redirect_to houses_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @house.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /houses/1
  # DELETE /houses/1.xml
  def destroy
    @house = House.find(params[:id])
    @house.destroy

    respond_to do |format|
      format.html { redirect_to(houses_url) }
      format.xml  { head :ok }
    end
  end
end
