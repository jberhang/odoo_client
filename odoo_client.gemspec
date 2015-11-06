$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "odoo_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "odoo_client"
  s.version     = OdooClient::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of OdooClient."
  s.description = "TODO: Description of OdooClient."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.2"

  s.add_development_dependency "sqlite3"
end
