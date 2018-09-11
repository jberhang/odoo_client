## Odoo Client - Ruby Client for Odoo ERP

This wrapper has been used with Odoo 8 and Odoo 9 installations. Please keep in mind that there are differences between some model names and associations between these versions. I highly recommend getting familiar with Odoo's 'Database Structure' admin settings under the Technical sub-menu and Odoo's documentation here:

* Odoo API docs
	* https://www.odoo.com/documentation/8.0/api_integration.html
	* https://www.odoo.com/documentation/9.0/api_integration.html
* Odoo ORM docs 
	* https://www.odoo.com/documentation/8.0/reference/orm.html
	* https://www.odoo.com/documentation/9.0/reference/orm.html

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'odoo_client', github: 'jberhang/odoo_client', branch: 'master'

```

And then execute:

$ bundle install

## Usage

```ruby
client = OdooClient::Client.new(url, database_name, username, password)

# get server version
result = client.version

# client.find allows ActiveRecord-like find of any model by id
# This example return a partner record with id=4
result = client.find('res.partner', 4)

# client.list_records returns an array of ids with given criteria
# This example returns all tag ids with the name attribute set to 'Web Lead'
result = client.list_records('crm.lead.tag', [['name', '=', 'Web Lead' ]] )

# client.read_records returns an array of full records with given criteria
# This example returns all sales teams records with the name not set to 'Direct Sales'
result = client.read_records('crm.team', [['name', '!=', 'Direct Sales' ]] )

# client.read_records with optional parameters (select_fields, offset, limit)
# This example returns only select fields for 50 leads modified since the beginning of the week
result = client.read_records('crm.lead', [['write_date', '>=', Time.now.beginning_of_week ]], ["user_id", "stage_id", "priority", "date_deadline", "date_closed"], 0, 50)

# client.delete_records removes all records with matching criteria 
# This example deletes all recgistrations attached to an event id
registrations = client.list_records("event.registration", [["event_id", "=", 6]])
client.delete_records("event.registration", registrations)

# client.count_records returns a count of records with given criteria
# This example counts event registrations for a given event id
result = client.count_records("event.registration", [["event_id", "=", 6]])

# count_records, delete_records, read_records, and list_records allow multiple filters seperated by commas
result = client.count_records("event.registration", [["event_id", "=", 6],["name", "!=", "Bob Smith"]])

# client.create_record creates a new record
# This example creates a new leads
record_params = { "contact_name" => "Bob Smith", 
				  "display_name" => "Opportunity: Bob Smith",
					  	  "phone" => "867-5309",
					  	  "city" => "New York",
					  	  "email_from" => "bsmith@gmail.com",
					  	  "user_id" => false,
					  	  "type" => "opportunity"}	
result = client.create_record('crm.lead', record_params)

# client.update_record update fields on a record for a given model
# This example updates the name and email of a customer record with id=5
result = client.update_record("res.partner", 5, {"name" => "Bobby Smith", "email" => "bsmith@icloud.com"})

# client.update_records update fields for more than 1 record
result = client.update_records("crm.lead", [5,6,7], {"referred" => "Yelp"})

# client.model_attributes returns a hash of all fields for a given model
result = client.model_attributes("crm.lead")
```

## TODO:

* Add gem versions
* Retrofit specs to gem
* Include service objects to manage common tasks in Odoo (requires schema knowledge of different Odoo versions "crm.case.categ vs lead.tags")


## Copyright

Copyright (c) 2015 Scratch Music Group. See LICENSE for details.
