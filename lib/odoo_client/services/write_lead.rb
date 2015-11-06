module OdooClient
	class WriteLead

		include ActionView::Helpers::TextHelper
		
		def initialize(contact. client)
			@contact = contact
			@client = client
		end

		def perform
	  	lead_type_tag_id = @client.list_records('crm.case.categ', [['name', '=', @contact.inquiry_type]] )[0]
	  	web_lead_tag_id = @client.list_records('crm.case.categ', [['name', '=', 'Web Lead' ]] )[0]
	  	sales_team_id = @client.find_academy_sales_team_id(@contact.city)

	  	display_name = "#{@contact.city} : #{@contact.inquiry_type}"

	    case @contact.inquiry_type
	    when "Event Services"
	    	description = "#{pluralize(@contact.attendees, 'person')} requested :: #{@contact.private_event_date.strftime("%B %d, %Y")} // #{@contact.comments}"
	    when "Open House"
	      description = @contact.odoo_event ? "Open House: #{@contact.odoo_event.start.strftime('%l:%M %p')}, #{ @contact.odoo_event.start.strftime('%B %d') }" : ""
	    else
	    	description = @contact.comments
	    end   

	  	@client.create_record('crm.lead', { "contact_name" => @contact.name, 
	  		"display_name" => display_name,
	  		"phone" => @contact.phone_number,
	  		"city" => @contact.city,
	  		"description" => description,
	  		"name" => display_name,
	  		"email_from" => @contact.email,
	  		"user_id" => false,
	  		"section_id" => sales_team_id,
	      # https://www.pivotaltracker.com/story/show/101543764
	      # 6 seems to specify an Odoo API version, but not 100% sure
	  		"categ_ids" => [ [ 6, false, [lead_type_tag_id, web_lead_tag_id ] ] ] }
	    )
		end	
	end
end