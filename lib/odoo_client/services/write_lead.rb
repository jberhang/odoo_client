module OdooClient
	class WriteLead

		include ActionView::Helpers::TextHelper
		
		def initialize(client, contact_params, sales_team)
			@contact_params = {"name" => "", "phone_number" => "", "city" => "", "email" => ""}.merge(contact_params.compact)
			@client = client
			@sales_team = sales_team
		end

		def perform
		  	#web_lead_tag_id = @client.list_records('crm.case.categ', [['name', '=', 'Web Lead' ]] )[0]
		  	#sales_team_id = @client.list_records('crm.case.section', [['name', '=', @sales_team ]] )[0]

		    record_params = { "contact_name" => @contact_params["name"], 
						  	  "display_name" => @contact_params["name"],
						  	  "phone" => @contact_params["phone_number"],
						  	  "city" => @contact_params["city"],
						  	  "description" => "#{@contact_params["comments"]} : Venue #{@contact_params["venue"]} : Preferred DJ #{@contact_params["preferred_dj"]}",
						  	  "name" => @contact_params["name"],
						  	  "email_from" => @contact_params["email"],
						  	  "user_id" => false}		

			#record_params["section_id"] = sales_team_id if sales_team_id
			#record_params["categ_ids"] = [ [ 6, false, [web_lead_tag_id] ] ] if web_lead_tag_id

			@client.create_record('crm.lead', record_params)
		end	
	end
end