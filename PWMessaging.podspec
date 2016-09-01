Pod::Spec.new do |s|
  s.name         = "PWMessaging"
  s.version      = "3.0.0"
  s.summary      = "Phunware Messaging SDK"
  s.homepage     = "http://phunware.github.io/maas-messaging-ios-sdk/"
  s.author       = { 'Phunware, Inc.' => 'http://www.phunware.com' }
  s.social_media_url = 'https://twitter.com/Phunware'

  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/sthummalapalli-phunware/maas-messaging-ios-sdk.git", :branch => 'master' }
  s.license      = { :type => 'Copyright', :text => 'Copyright 2016 by Phunware Inc. All rights reserved.' }

  s.ios.vendored_frameworks = 'Framework/PWMessaging.framework'
  s.xcconfig      = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/PWMessaging/**"'}
  
  s.dependency 'PWCore', '~> 3.0.0'
  
  s.library = 'sqlite3', 'z'
  s.ios.frameworks = 'CoreLocation'
  s.requires_arc  = true
  
end