Pod::Spec.new do |s|
  s.name = 'SelectionViewController'
  s.version = '1.3'
  s.license = { :type => 'MIT' }
  s.summary = 'Use stack views on iOS 8 & 9.'
  s.homepage = 'https://github.com/thedistance'
  s.author       = { "The Distance" => "dev@thedistance.co.uk" }
  s.source = { :git => 'https://github.com/TheDistance/SelectionViewController.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SelectionViewController/Classes/**/*.swift'
  s.requires_arc = true
end
