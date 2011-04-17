require 'iconv'
require 'csv'
class BranchesController < ApplicationController
  BOM = "\377\376" #Byte Order Mark
  before_filter :authenticate_user!
  # GET /branches
  # GET /branches.xml
  def index
  	@title = "toutes les agences"
    @branches = Branch.all
    respond_to do |format|
		format.html # index.html.erb
		format.xml  { render :xml => @branches }
		format.iphone { render :layout => false }
		format.csv do
			filename = I18n.l(Time.now, :format => :short) + "- branches.csv"	
	      	csv_string = CSV.generate do |csv|
		        # header row
		        csv << ["Id", "Name", "Description", "Entite"]
		
		        # data rows
		        @branches.each do |branch|
		          csv << [ branch.id,
	           			   branch.name,
	           			   branch.description,
	           			   branch.entity.description]
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

  # GET /branches/1
  # GET /branches/1.xml
  def show
    @branch = Branch.find(params[:id])
  	@title = @branch.description + " - " + @branch.name 
    @interventions = @branch.events.order("coalesce(cancelled,done,planned) ASC")

    respond_to do |format|
      format.html # show.html.erb
      format.iphone { render :layout => false } # show.iphone.erb
      format.xml  { render :xml => @branch }
    end
  end

  # GET /branches/new
  # GET /branches/new.xml
  def new
    @branch = Branch.new
    @entities = Entity.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @branch }
    end
  end

  # GET /branches/1/edit
  def edit
    @branch = Branch.find(params[:id])
    @entities = Entity.find(:all)
  end

  # POST /branches
  # POST /branches.xml
  def create
    @branch = Branch.new(params[:branch])

    respond_to do |format|
      if @branch.save
        format.html { redirect_to(@branch, :notice => 'Branch was successfully created.') }
        format.xml  { render :xml => @branch, :status => :created, :location => @branch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /branches/1
  # PUT /branches/1.xml
  def update
    @branch = Branch.find(params[:id])

    respond_to do |format|
      if @branch.update_attributes(params[:branch])
        format.html { redirect_to(@branch, :notice => 'Branch was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.xml
  def destroy
    @branch = Branch.find(params[:id])
    @branch.destroy

    respond_to do |format|
      format.html { redirect_to(branches_url) }
      format.xml  { head :ok }
    end
  end
end
