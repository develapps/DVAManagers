#
# Be sure to run `pod lib lint DVAManagers.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DVAManagers"
  s.version          = "1.0.0"
  s.summary          = "Common DVAManagers for iOS Apps"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://bitbucket.org/dvalibs/DVAManagers"
  s.license          = 'MIT'
  s.author           = { "Pablo Romeu" => "pablo.romeu@develapps.com" }
    s.source           = {      :git => "https://bitbucket.com/DVALibs/DVAManagers.git",
                                :tag => s.version.to_s,
                                :submodules => true }
  s.social_media_url = 'https://twitter.com/pabloromeu'

  s.platform     = :ios, '9.0'
  s.requires_arc = true


    s.source_files = 'Pod/Classes/DVAManagers.h'
    s.public_header_files = 'Pod/Classes/DVAManagers.h'

    s.subspec 'DVANetworkPaginatedResource' do |ss|
        ss.dependency 'AFNetworking', '~> 2.6'
        ss.dependency 'DVACache', '~>1.1'
        ss.source_files = 'Pod/Classes/DVANetworkPaginatedResource/*.{h,m}'
        ss.public_header_files = 'Pod/Classes/DVANetworkPaginatedResource/*.{h}'
    end

    s.subspec 'DVAPhotoPickerManager' do |ss|
        ss.frameworks = 'MobileCoreServices'
        ss.source_files = 'Pod/Classes/DVAPhotoPickerManager/*.{h,m}'
        ss.public_header_files = 'Pod/Classes/DVAPhotoPickerManager/*.{h}'
    end

    s.subspec 'DVALocationManager' do |ss|
        ss.frameworks = 'CoreLocation'
        ss.source_files = 'Pod/Classes/DVALocationManager/*.{h,m}'
        ss.public_header_files = 'Pod/Classes/DVALocationManager/*.{h}'
    end

    s.subspec 'DVAFacebookManager' do |ss|
        ss.dependency 'FBSDKCoreKit', '~> 4.8'
        ss.dependency 'FBSDKLoginKit', '~> 4.8'
        ss.dependency 'FBSDKShareKit', '~> 4.8'
        ss.dependency 'DVACache', '~>1.1'
        ss.source_files = 'Pod/Classes/DVAFacebookManager/*.{h,m}'
        ss.public_header_files = 'Pod/Classes/DVAFacebookManager/*.{h}'
    end
end
