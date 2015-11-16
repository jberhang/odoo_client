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

		private
			def models
				@models ||= XMLRPC::Client.new2("#{@url}/xmlrpc/2/object").proxy
			end

	end	
end