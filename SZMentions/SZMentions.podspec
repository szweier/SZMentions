Pod::Spec.new do |s|
  s.name             = "SZMentions"
  s.version          = "0.0.1"
  s.summary          = "Highly customizable mentions library"
  s.description      = s.summary
  s.homepage         = "http://www.stevenzweier.com"
  s.license          = 'proprietary'
  s.author           = { "Steven Zweier" => "steve.zweier+mentions@gmail.com" }
  s.source           = { :git => "", :tag => s.version.to_s }
  s.platform     = :ios, '7.1'
  s.requires_arc = true
  s.source_files = 'Classes/**/*'

  s.resource_bundles = {
    'SZMentions' => ['Assets/*']
    }

end

