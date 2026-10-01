Gem::Specification.new do |s|
  s.name = "active-sequel"
  s.version = "0.1.0"
  s.summary = "ActiveRecord to Sequel adapter"
  s.authors = ["Mauricio Szabo"]
  s.files = Dir["lib/**/*.rb"]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 3.0"

  s.add_dependency "activerecord", ">= 7.0"
  s.add_dependency "sequel", ">= 5.0"
  s.add_dependency "sequel-activerecord_connection", ">= 2.0"

  s.add_development_dependency "rspec", "~> 3.13"
  s.add_development_dependency "sqlite3", ">= 1.4"
end
