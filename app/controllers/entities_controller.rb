require 'iconv'
require 'csv'
class EntitiesController < ApplicationController
	
  include GmailsHelper

  BOM = "\377\376" #Byte Order Mark
  before_filter :authenticate_user!
 
  # GET /entities
  # GET /entities.xml
  def index
    @entities = Entity.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entities }
	  format.csv do
			filename = I18n.l(Time.now, :format => :short) + "- entities.csv"	
	      	csv_string = CSV.generate do |csv|
		        # header row
		        csv << ["Id", "Name", "Description"]
		
		        # data rows
		        @entities.each do |entity|
		          csv << [ entity.id,
	           			   entity.name,
	           			   entity.description]
		        end
			end
		# csv_string = BOM + Iconv.conv("utf-16le", "utf-8", csv_string)
	    # send it to the browsah
	    send_data csv_string,
	                :type => 'text/csv; charset=utf-8; header=present',
	                :disposition => "attachment;",
	                :filename => filename
		end    
	end
  end

  # GET /entities/1
  # GET /entities/1.xml
  def show
    @entity = Entity.find(params[:id])
    @data = @entity.branches
    @map = set_gmail(@data)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entity }
    end
  end

  # GET /entities/new
  # GET /entities/new.xml
  def new
    @entity = Entity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entity }
    end
  end

  # GET /entities/1/edit
  def edit
    @entity = Entity.find(params[:id])
  end

  # POST /entities
  # POST /entities.xml
  def create
    @entity = Entity.new(params[:entity])

    respond_to do |format|
      if @entity.save
        format.html { redirect_to(@entity, :notice => 'Entity was successfully created.') }
        format.xml  { render :xml => @entity, :status => :created, :location => @entity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entities/1
  # PUT /entities/1.xml
  def update
    @entity = Entity.find(params[:id])

    respond_to do |format|
      if @entity.update_attributes(params[:entity])
        format.html { redirect_to(@entity, :notice => 'Entity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entities/1
  # DELETE /entities/1.xml
  def destroy
    @entity = Entity.find(params[:id])
    @entity.destroy

    respond_to do |format|
      format.html { redirect_to(entities_url) }
      format.xml  { head :ok }
    end
  end
end
