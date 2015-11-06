require "xmlrpc/client"

module OdooClient
	class Client

		class AuthenticationError < StandardError
		end

		def initialize(url, database, username, password)
			@url = url
			@common = XMLRPC::Client.new2("#{@url}/xmlrpc/2/common")
			@db = database
			@password = password

			@uid = @common.call('authenticate', @db, username, @password, {})

			raise AuthenticationError.new unless @uid == 1
		end

		def version
			@common.call('version')["server_version"]
		end

		def count_records(model_name, filters=[])
			models.execute_kw(@db, @uid, @password, model_name, 'search_count', [filters], {})
		end	

		def list_records(model_name, filters=[])
			models.execute_kw(@db, @uid, @password, model_name, 'search', [filters], {})
		end

		def read_records(model_name, filters=[])
			models.execute_kw(@db, @uid, @password, model_name, 'search_read', [filters], {})
		end

		def create_record(model_name, params)
			models.execute_kw(@db, @uid, @password, model_name, 'create', [params])
		end

		def update_record(model_name, id, params)
			models.execute_kw(@db, @uid, @password, model_name, 'write', [[id], params])
		end

		def delete_records(model_name, params)
			models.execute_kw(@db, @uid, @password, model_name, 'unlink', [params])
		end


		def find(model_name, id)
			result = read_records(model_name, [["id", "=", id]])
			result[0] unless result.empty?
		end	

		# these probably need to be moved out
		def upcoming_events(odoo_product_id, odoo_parent_location="Scratch NYC")
			location_ids = list_records("res.partner", [["type", "=", "contact"], ["parent_name", "=", odoo_parent_location]])
			# can we only pull tickets that are pending???
			tickets = read_records("event.event.ticket", [["product_id", "=", odoo_product_id]])
			event_ids = tickets.map {|t| t["event_id"].first}
			events = read_records("event.event",[["id", "in", event_ids], ["address_id", "in", location_ids], ["date_begin", ">=", Time.zone.today.to_s]])
		end

		def count_event_registrations(odoo_event_id)
			count_records("event.registration", [["event_id", "=", odoo_event_id]])
		end

		def find_state_id(state)
			state_ids = list_records("res.country.state", [["name", "=", state]])
			if state_ids.any?
				state_ids.first 
			else
				#this gets crazy when the user puts in fake..ish address
				list_records('res.country.state', [['name','=','New York']]).first
			end
		end

		def find_country_id(country)
			country = "United States" if country == "United States of America"
			country_ids = list_records("res.country", [["name", "=", country]])
			country_ids.first if country_ids.any?
		end	

		def find_academy_sales_team_id(city)
			team_name = "Academy Sales / #{city}"
			section_ids = list_records('crm.case.section', [['complete_name', '=', team_name]] )
			if section_ids.any?
				section_ids.first 
			else
				list_records('crm.case.section', [['complete_name', '=', "Academy Sales"]] ).first
			end
		end

		def find_customer_id(customer_email)
			partner_ids = list_records("res.partner", [["email", "=ilike", customer_email]])
			partner_ids.first if partner_ids.any?
		end

		private
			def models
				@models ||= XMLRPC::Client.new2("#{@url}/xmlrpc/2/object").proxy
			end

	end	
end