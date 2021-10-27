Gem::Specification.new do |spec|
  spec.name         = "ttylenium"
  spec.version      = "0.0.0"
  spec.summary      = "Access and test terminal session like a table of chars."

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/ttylenium"}

  spec.add_dependency "ferrum"
  spec.add_dependency "rubyzip"

  spec.files        = %w{ LICENSE ttylenium.gemspec lib/ttylenium.rb }
end
