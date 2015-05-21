Pod::Spec.new do |s|
  s.name         = "Mantle-HAL-Remix"
  s.version      = "1.0.0"
  s.summary      = "HAL Parser for Objective-C with added strong typing."
  s.homepage     = "https://www.github.com/remixnine/Mantle-HAL-Remix"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Lynn Zhou" => "lynn@lynnzhou.com" }
  s.social_media_url = 'https://twitter.com/remixnine'
  s.source       = { :git => "https://github.com/remixnine/Mantle-HAL-Remix.git", :tag => "1.0.0" }
  
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  
  s.source_files = "Classes", "*.{h,m}"
  s.requires_arc = true
  s.dependency "Mantle", "~> 1.5"
end