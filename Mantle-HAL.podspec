Pod::Spec.new do |s|
  s.name         = "Mantle-HAL"
  s.version      = "0.0.1"
  s.summary      = "HAL Parser for Objective-C with added strong typing."
  s.homepage     = "https://www.github.com/simonrice/Mantle-HAL"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Simon Rice" => "im@simonrice.com" }
  s.source       = { :git => "https://github.com/simonrice/Mantle-HAL.git", :tag => "0.0.1" }
  s.platform     = :ios, "6.0"
  s.source_files = "Classes", "*.{h,m}"
  s.requires_arc = true
  s.dependency "Mantle", "~> 1.5"
end
