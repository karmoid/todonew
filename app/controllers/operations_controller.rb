class OperationsController < ApplicationController
  before_filter :authenticate_user!
  # GET /operations
  # GET /operations.xml
  def index
    @operations = Operation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @operations }
    end
  end

  # GET /operations/1
  # GET /operations/1.xml
  def show
    @operation = Operation.find(params[:id])
    @events = @operation.events
    
    @interventions = Event.find :all, 
                                :joins => :operation, 
                                :conditions => ["operations.id = ?",@operation.id],
                                :order => "coalesce(cancelled,done,planned) ASC"
    
    #.where(
    # 	"(planned between :startdate and :enddate) or "+
    #    "(done between :startdate and :enddate) or "+
    #    "(cancelled between :startdate and :enddate)",
    #	{:startdate => Date.current-21, :enddate => Date.current+15}).
  	#	order("planned ASC")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @operation }
    end
  end

  # GET /operations/new
  # GET /operations/new.xml
  def new
    @operation = Operation.new
    @opegroups = Opegroup.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @operation }
    end
  end

  # GET /operations/1/edit
  def edit
    @operation = Operation.find(params[:id])
    @opegroups = Opegroup.find(:all)
  end

  # POST /operations
  # POST /operations.xml
  def create
    @operation = Operation.new(params[:operation])

    respond_to do |format|
      if @operation.save
        format.html { redirect_to(@operation, :notice => 'Operation was successfully created.') }
        format.xml  { render :xml => @operation, :status => :created, :location => @operation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @operation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /operations/1
  # PUT /operations/1.xml
  def update
    @operation = Operation.find(params[:id])

    respond_to do |format|
      if @operation.update_attributes(params[:operation])
        format.html { redirect_to(@operation, :notice => 'Operation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @operation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /operations/1
  # DELETE /operations/1.xml
  def destroy
    @operation = Operation.find(params[:id])
    @operation.destroy

    respond_to do |format|
      format.html { redirect_to(operations_url) }
      format.xml  { head :ok }
    end
  end
end
