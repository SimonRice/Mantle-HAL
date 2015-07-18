Pod::Spec.new do |s|
  s.name             = "Mantle-HAL"
  s.version          = "1.1.0"
  s.summary          = "HAL Parser for Objective-C with added strong typing."
  s.homepage         = "https://github.com/simonrice/Mantle-HAL"
  s.license          = 'MIT'
  s.author           = { "Simon Rice" => "im@simonrice.com" }
  s.source           = { :git => "https://github.com/simonrice/Mantle-HAL.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_simonrice'
  
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'Mantle', '~> 1.5'
  s.requires_arc = true
  s.module_name = 'MantleHAL'
end
