gem = Gem::Specification.new

gem.name = 'ovh-telecom-control'
gem.version = `git log -1 --format=%ct`
gem.author = 'Alex Leferry 2>'
gem.email = 'alexherbo2@gmail.com'
gem.summary = 'OVH Telecom API for Humans'
gem.homepage = 'https://github.com/alexherbo2/ovh-telecom-control.rb'
gem.license = 'Unlicense'

gem.add_runtime_dependency 'ovh-api'
gem.add_runtime_dependency 'celluloid'

gem.files = `git ls-files`.split

gem
