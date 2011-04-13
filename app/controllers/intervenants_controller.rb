class IntervenantsController < ApplicationController
  before_filter :authenticate_user!
  # GET /intervenants
  # GET /intervenants.xml
  def index
    @intervenants = Intervenant.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @intervenants }
    end
  end

  # GET /intervenants/1
  # GET /intervenants/1.xml
  def show
    @intervenant = Intervenant.find(params[:id])
    @interventions = @intervenant.events.order("eventable_type ASC, eventable_id ASC, coalesce(cancelled,done,planned) ASC")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @intervenant }
    end
  end

  # GET /intervenants/new
  # GET /intervenants/new.xml
  def new
    @intervenant = Intervenant.new
    @entities = Entity.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @intervenant }
    end
  end

  # GET /intervenants/1/edit
  def edit
    @intervenant = Intervenant.find(params[:id])
    @entities = Entity.find(:all)
  end

  # POST /intervenants
  # POST /intervenants.xml
  def create
    @intervenant = Intervenant.new(params[:intervenant])

    respond_to do |format|
      if @intervenant.save
        format.html { redirect_to(@intervenant, :notice => 'Intervenant was successfully created.') }
        format.xml  { render :xml => @intervenant, :status => :created, :location => @intervenant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @intervenant.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @intervenant = Intervenant.find(params[:id])

    respond_to do |format|
      if @intervenant.update_attributes(params[:intervenant])
        format.html { redirect_to(@intervenant, :notice => 'Intervenant was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @intervenant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /intervenants/1
  # DELETE /intervenants/1.xml
  def destroy
    @intervenant = Intervenant.find(params[:id])
    @intervenant.destroy

    respond_to do |format|
      format.html { redirect_to(intervenants_url) }
      format.xml  { head :ok }
    end
  end
  
end
