Pod::Spec.new do |s|
  s.name         = "Mantle-HAL"
  s.version      = "1.0.0"
  s.summary      = "HAL Parser for Objective-C with added strong typing."
  s.homepage     = "https://www.github.com/simonrice/Mantle-HAL"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Simon Rice" => "im@simonrice.com" }
  s.source       = { :git => "https://github.com/simonrice/Mantle-HAL.git", :tag => "1.0.0" }
  
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.dependency "Mantle", "~> 1.5"
  s.source_files = "Classes", "*.{h,m}"
  s.public_header_files = "Classes/*.h"
  s.requires_arc = true
  s.module_name = 'MantleHAL'
end
