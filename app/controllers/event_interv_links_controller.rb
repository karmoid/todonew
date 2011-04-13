class EventIntervLinksController < ApplicationController
  before_filter :authenticate_user!
  def update
    @intervenant = Intervenant.find(params[:id])
    get_parents
    respond_to do |format|
      if @event.intervenants << @intervenant
        format.html { redirect_to(eval(@parent.class.to_s.downcase+"_event_path(@parent,@event)"), :notice => 'Intervenant was successfully added.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to(eval(@parent.class.to_s.downcase+"_event_path(@parent,@event)"), :notice => "Intervenant was'nt successfully added.") }
        format.xml  { render :xml => @event.event_interv_links.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
  	get_parents
  	event_link = @event.event_interv_links.find_by_intervenant_id(params[:id])
    respond_to do |format|
      if event_link.destroy
        format.html { redirect_to(eval(@parent.class.to_s.downcase+"_event_path(@parent,@event)"), :notice => 'Intervenant was successfully removed.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to(eval(@parent.class.to_s.downcase+"_event_path(@parent,@event)"), :notice => "Intervenant was'nt successfully removed.") }
        format.xml  { render :xml => @event.event_interv_links.errors, :status => :unprocessable_entity }
      end
    end
  end

private

  def get_parents
    @parent ||= case
      when params[:server_id] then Server.find(params[:server_id])
      when params[:instance_id] then Instance.find(params[:instance_id])
      when params[:branch_id] then Branch.find(params[:branch_id])
    end
    @event = Event.find(params[:event_id])
  end  	

end
