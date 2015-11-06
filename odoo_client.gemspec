$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "odoo_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "odoo_client"
  s.version     = OdooClient::VERSION
  s.authors     = ["Justin Berhang"]
  s.email       = ["justin@scratch.com"]
  s.homepage    = "https://github.com/jberhang/odoo_client"
  s.summary     = "Ruby Client for Odoo ERP."
  s.description = "Ruby Client for Odoo ERP."
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
end
