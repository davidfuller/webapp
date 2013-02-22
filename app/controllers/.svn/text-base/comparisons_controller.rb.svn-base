class ComparisonsController < ApplicationController
  
  def calculate
    calc
    redirect_to(comparison_path_with_filter_and_filename)
  end
  
  def add
    stats = Title.add_from_playlist_comparison(Comparison.find(params[:id]))
    added = stats[:added]
    house_added = stats[:house_added]
    issues = stats[:issues]
    house_issues = stats[:house_issues]
    notice = stats[:notice]
    flash[:notice] = ""
    flash[:notice] += @template.pluralize(added, 'Title') + ' added. ' if added > 0
    flash[:notice] += @template.pluralize(house_added, 'House Number') + ' added. ' if house_added > 0 
    flash[:notice] += @template.pluralize(issues, 'Title issue') + '. ' if issues > 0
    flash[:notice] += @template.pluralize(house_issues, 'House Number issue') + '. ' if house_issues > 0
    flash[:notice] += notice
    redirect_to(comparison_path_with_filter_and_filename)
  end
  
  def add_multiple
    if params[:comparison_ids] != nil
      flash[:notice] = ""
      notice=""
      added = 0
      house_added = 0
      issues = 0
      house_issues = 0
      params[:comparison_ids].each do |id| 
        stats = Title.add_from_playlist_comparison(Comparison.find(id))
        added += stats[:added]
        house_added += stats[:house_added]
        issues += stats[:issues]
        house_issues += stats[:house_issues]
        notice += stats[:notice]
      end
      flash[:notice] += @template.pluralize(added, 'Title') + ' added. ' if added > 0
      flash[:notice] += @template.pluralize(house_added, 'House Number') + ' added. ' if house_added > 0 
      
      flash[:notice] += @template.pluralize(issues, 'Title issue') + '. ' if issues > 0
      flash[:notice] += @template.pluralize(house_issues, 'House Number issue') + '. ' if house_issues > 0
      flash[:notice] += notice
    else
      flash[:notice] = "Nothing checked"
    end
    redirect_to(comparison_path_with_filter_and_filename)
  end
  
  def calc (filename_id)
    Comparison.delete_all
    PlaylistLine.full_progs_part1.find_all_by_playlist_filename_id(filename_id).each do |p|
      press = PressLine.find_by_start_and_channel(p.rounded, p.playlist_filename.channel)
      Comparison.add_prog(p, press)
    end
  end
  
  
  # GET /comparisons
  # GET /comparisons.xml
  def index
    calc(params[:filename])

    @filter_display = Comparison.filter_display
    @filters = Comparison::FILTERS
    @filenames = PlaylistFilename.display
        
    if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
     @comparisons = Comparison.send(params[:show])

    else
      @comparisons = Comparison.all :order => :rounded
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comparisons }
    end
  end

  # GET /comparisons/1
  # GET /comparisons/1.xml
  def show
    @comparison = Comparison.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comparison }
    end
  end

  # GET /comparisons/new
  # GET /comparisons/new.xml
  def new
    @comparison = Comparison.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comparison }
    end
  end

  # GET /comparisons/1/edit
  def edit
    @comparison = Comparison.find(params[:id])
  end

  # POST /comparisons
  # POST /comparisons.xml
  def create
    @comparison = Comparison.new(params[:comparison])

    respond_to do |format|
      if @comparison.save
        flash[:notice] = 'Comparison was successfully created.'
        format.html { redirect_to(@comparison) }
        format.xml  { render :xml => @comparison, :status => :created, :location => @comparison }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comparison.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comparisons/1
  # PUT /comparisons/1.xml
  def update
    @comparison = Comparison.find(params[:id])

    respond_to do |format|
      if @comparison.update_attributes(params[:comparison])
        flash[:notice] = 'Comparison was successfully updated.'
        format.html { redirect_to(@comparison) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comparison.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comparisons/1
  # DELETE /comparisons/1.xml
  def destroy
    @comparison = Comparison.find(params[:id])
    @comparison.destroy

    respond_to do |format|
      format.html { redirect_to(comparisons_url) }
      format.xml  { head :ok }
    end
  end
end
