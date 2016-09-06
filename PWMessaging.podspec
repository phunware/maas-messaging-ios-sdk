Pod::Spec.new do |s|
  s.name         = "PWMessaging"
  s.version      = "3.0.0"
  s.summary      = "Phunware Messaging SDK"
  s.homepage     = "http://phunware.github.io/maas-messaging-ios-sdk/"
  s.author       = { 'Phunware, Inc.' => 'http://www.phunware.com' }
  s.social_media_url = 'https://twitter.com/Phunware'

  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/phunware/maas-messaging-ios-sdk.git", :tag => 'v3.0.0' }
  s.license      = { :type => 'Copyright', :text => 'Copyright 2016 by Phunware Inc. All rights reserved.' }

https://github.com/phunware/maas-messaging-ios-sdk.git


  s.ios.vendored_frameworks = 'Framework/PWMessaging.framework'
  s.xcconfig      = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/PWMessaging/**"'}
  
  s.dependency 'PWCore'
  
  s.library = 'sqlite3', 'z'
  s.ios.frameworks = 'CoreLocation'
  s.requires_arc  = true
  
end