module GmailsHelper
	def set_gmail(data)
    	map = Cartographer::Gmap.new( 'map' )		
		map.zoom = :bound
		icon_org1 = Cartographer::Gicon.new(:name => "agence1",
		      :image_url => '/images/status_offline.png',
		      :shadow_url => '/images/status_offline.png',
		      :width => 32,
		      :height => 23,
		      :shadow_width => 32,
		      :shadow_height => 23,
		      :anchor_x => 0,
		      :anchor_y => 20,
		      :info_anchor_x => 5,
		      :info_anchor_x => 1)
		map.icons <<  icon_org1
		icon_org2 = Cartographer::Gicon.new(:name => "agence2",
		      :image_url => '/images/status_away.png',
		      :shadow_url => '/images/status_away.png',
		      :width => 32,
		      :height => 23,
		      :shadow_width => 32,
		      :shadow_height => 23,
		      :anchor_x => 0,
		      :anchor_y => 20,
		      :info_anchor_x => 5,
		      :info_anchor_x => 1)
		map.icons << icon_org2
		icon_org3 = Cartographer::Gicon.new(:name => "agence3",
		      :image_url => '/images/status_online.png',
		      :shadow_url => '/images/status_online.png',
		      :width => 32,
		      :height => 23,
		      :shadow_width => 32,
		      :shadow_height => 23,
		      :anchor_x => 0,
		      :anchor_y => 20,
		      :info_anchor_x => 5,
		      :info_anchor_x => 1)
		map.icons <<  icon_org3
		icon_org4 = Cartographer::Gicon.new(:name => "agence4",
		      :image_url => '/images/status_pending.png',
		      :shadow_url => '/images/status_pending.png',
		      :width => 32,
		      :height => 23,
		      :shadow_width => 32,
		      :shadow_height => 23,
		      :anchor_x => 0,
		      :anchor_y => 20,
		      :info_anchor_x => 5,
		      :info_anchor_x => 1)
		map.icons <<  icon_org4
		icon_org5 = Cartographer::Gicon.new(:name => "agence5",
		      :image_url => '/images/status_busy.png',
		      :shadow_url => '/images/status_busy.png',
		      :width => 32,
		      :height => 23,
		      :shadow_width => 32,
		      :shadow_height => 23,
		      :anchor_x => 0,
		      :anchor_y => 20,
		      :info_anchor_x => 5,
		      :info_anchor_x => 1)
		map.icons <<  icon_org5
		# Add the icons to map
		cpt = 0
		data.each {|d|
			if ! (d.lat.nil? || d.long.nil?)
		        map.markers << Cartographer::Gmarker.new(:name=> "agc"+cpt.to_s, :marker_type => "agence"+d.refreshed.to_s,
		        :position => [d.lat, d.long],
		        :info_window_url => "/welcome/sample_ajax/"+d.id.to_s,
		        :icon => map.icons[d.refreshed-1])
		    	cpt = cpt + 1
		    end	
		}
		return map
	end
end	

module PrettyDate
	def to_pretty
		if self.to_date <= Time.now.to_date
			a = (Time.now.to_date-self.to_date).to_i
			case a
			  when 0 then return "Aujourd'hui"
			  when 1 then return "Hier"
			  when 2 then return "Avant-hier"
			  when 3..6 then return "La semaine passee" 
			  when 7..13 then return "Il y a plus d'une semaine" #120 = 2 minutes
			  when 14..21 then return "Il y a plus de deux semaines"
			  when 22..28 then return "Il y a plus de trois semaines" # 3600 = 1 hour
			  when 29..60 then return "Il y a plus d'un mois" 
			  when 61..90 then return "Il y a plus de deux mois" # 86400 = 1 day
			  when 91..120 then return "Il y a plus de trois mois" # 86400 = 1 day
			  when 121..365 then return "Il y a moins d'un an"
			  when 366..1036800 then return "Il y a plus d'un an"
			  else return "il y a fort longtemps"
			end
		else	
			a = (self.to_date-Time.now.to_date).to_i
			case a
			  when 0 then return "Aujourd'hui"
			  when 1 then return "Demain"
			  when 2 then return "Apres-Demain"
			  when 3..6 then return "La semaine a venir" 
			  when 7..13 then return "Dans plus d'une semaine" #120 = 2 minutes
			  when 14..21 then return "Dans plus de deux semaines"
			  when 22..28 then return "Dans plus de trois semaines" # 3600 = 1 hour
			  when 29..60 then return "Dans plus d'un mois" 
			  when 61..90 then return "Dans plus de deux mois" # 86400 = 1 day
			  when 91..120 then return "Dans plus de trois mois" # 86400 = 1 day
			  when 121..365 then return "Dans moins d'un an"
			  when 366..1036800 then return "Dans plus d'un an"
			  else return "Dans tres longtemps"
			end
		end	
	end
end

Time.send :include, PrettyDate
Date.send :include, PrettyDate