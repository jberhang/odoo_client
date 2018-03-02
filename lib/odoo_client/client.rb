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

		def read_records(model_name, filters=[], select_fields=[], offset=nil, limit=nil)
			optional_params = {fields: select_fields}
			optional_params[:offset] = offset unless offset.nil?
			optional_params[:limit] = limit unless limit.nil?
			models.execute_kw(@db, @uid, @password, model_name, 'search_read', [filters], optional_params)
		end

		def create_record(model_name, params)
			models.execute_kw(@db, @uid, @password, model_name, 'create', [params])
		end

		def update_record(model_name, id, params)
			update_records(model_name, [id], params)
		end

		def update_records(model_name, record_ids, params)
			models.execute_kw(@db, @uid, @password, model_name, 'write', [record_ids, params])
		end

		def delete_records(model_name, params)
			models.execute_kw(@db, @uid, @password, model_name, 'unlink', [params])
		end

		def model_attributes(model_name, info=['string', 'help', 'type'])
			models.execute_kw(@db, @uid, @password, model_name, 'fields_get', [], {'attributes': info})
		end

		def find(model_name, id, select_fields=[])
			result = read_records(model_name, [["id", "=", id]], select_fields)
			result[0] unless result.empty?
		end	

		private
			def models
				@models ||= XMLRPC::Client.new2("#{@url}/xmlrpc/2/object").proxy
			end

	end	
end