class OpegroupsController < ApplicationController
  before_filter :authenticate_user!
  # GET /opegroups
  # GET /opegroups.xml
  def index
    @opegroups = Opegroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @opegroups }
    end
  end

  # GET /opegroups/1
  # GET /opegroups/1.xml
  def show
    @opegroup = Opegroup.find(params[:id])
#query = <<ENDTXT
#ENDTXT
#    sql = ActiveRecord::Base.connection();
#    @tableau =
#  	  sql.select_all(query)    
    #@interventions = []
    # @opegroup.operations.collect {|o| o.events.each {|e| @interventions << e}}
    @interventions = Event.find :all, 
                                :joins => {:operation => :opegroup}, 
                                :conditions => ["operations.opegroup_id = ?",@opegroup.id],
                                :order => "coalesce(cancelled,done,planned) ASC"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @opegroup }
    end
  end

  # GET /opegroups/new
  # GET /opegroups/new.xml
  def new
    @opegroup = Opegroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @opegroup }
    end
  end

  # GET /opegroups/1/edit
  def edit
    @opegroup = Opegroup.find(params[:id])
  end

  # POST /opegroups
  # POST /opegroups.xml
  def create
    @opegroup = Opegroup.new(params[:opegroup])

    respond_to do |format|
      if @opegroup.save
        format.html { redirect_to(@opegroup, :notice => 'Opegroup was successfully created.') }
        format.xml  { render :xml => @opegroup, :status => :created, :location => @opegroup }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @opegroup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /opegroups/1
  # PUT /opegroups/1.xml
  def update
    @opegroup = Opegroup.find(params[:id])

    respond_to do |format|
      if @opegroup.update_attributes(params[:opegroup])
        format.html { redirect_to(@opegroup, :notice => 'Opegroup was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @opegroup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /opegroups/1
  # DELETE /opegroups/1.xml
  def destroy
    @opegroup = Opegroup.find(params[:id])
    @opegroup.destroy

    respond_to do |format|
      format.html { redirect_to(opegroups_url) }
      format.xml  { head :ok }
    end
  end
end
