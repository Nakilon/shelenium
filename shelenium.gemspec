Gem::Specification.new do |spec|
  spec.name         = "shelenium"
  spec.version      = "0.0.0"
  spec.summary      = "Access and test terminal session like a table of chars."

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/shelenium"}

  spec.add_dependency "ferrum"
  spec.add_dependency "rubyzip"

  spec.files        = %w{ LICENSE shelenium.gemspec lib/shelenium.rb }
end
