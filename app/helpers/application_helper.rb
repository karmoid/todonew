module ApplicationHelper
   # Return a title on a per-page basis.
   def title
      base_title = "Suivi interventions"
      if @title.nil?
         base_title
      else
         "#{base_title} | #{@title}"
      end
   end
   
  def sprite(name, options = {})
    defaults = {:class => "ss_sprite ss_#{name}"}
    if options[:class]
      defaults[:class] << " #{options.delete(:class)}"
    end
    content_tag(:span, "~", defaults.merge!(options)).gsub("~","&nbsp;")
  end   
	
end
