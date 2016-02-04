Pod::Spec.new do |s|
  s.name             = "SZMentions"
  s.version          = "0.0.15"
  s.summary          = "Highly customizable mentions library"
  s.description      = "Mentions library used to help manage mentions in a UITextView"
  s.homepage         = "http://www.stevenzweier.com"
  s.license          = 'MIT'
  s.author           = { "Steven Zweier" => "steve.zweier+mentions@gmail.com" }
  s.source           = { :git => "https://github.com/szweier/SZMentions.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.1'
  s.requires_arc = true
  s.source_files = 'SZMentions/SZMentions/Classes/**/*'

  s.resource_bundles = {
    'SZMentions' => ['SZMentions/SZMentions/Assets/*']
    }

end

