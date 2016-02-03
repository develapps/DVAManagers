Pod::Spec.new do |s|
  s.name = 'DVAManagers'
  s.version = '1.2.0'
  s.summary = 'Common DVAManagers for iOS Apps'
  s.license = 'MIT'
  s.authors = {"Pablo Romeu"=>"pablo.romeu@develapps.com"}
  s.homepage = 'https://bitbucket.org/dvalibs/dvamanagers'
  s.description = 'This pod implements managers for common tasks like:
- Using a paginated resource
- Photo picker
- Location Manager
- Facebook Manager

New 1.1.0
---------
Added cache types at paginated resource'
  s.social_media_url = 'https://twitter.com/pabloromeu'
  s.requires_arc = true
  s.source = {}

  s.platform = :ios, '9.0'
  s.ios.platform             = :ios, '9.0'
  s.ios.preserve_paths       = 'ios/DVAManagers.framework'
  s.ios.public_header_files  = 'ios/DVAManagers.framework/Versions/A/Headers/*.h'
  s.ios.resource             = 'ios/DVAManagers.framework/Versions/A/Resources/**/*'
  s.ios.vendored_frameworks  = 'ios/DVAManagers.framework'
end
