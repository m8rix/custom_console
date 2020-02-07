Gem::Specification.new do |spec|
  spec.name          = "robot"
  spec.version       = "0.1.0"
  spec.authors       = ["Steve"]
  spec.email         = ["m8trix@gmail.com"]
  spec.summary       = "Code challenge"
  spec.description   = "Code challenge"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
