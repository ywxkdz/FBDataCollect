#
# Be sure to run `pod lib lint FBPrivateCollect.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FBPrivateCollect'
  s.version          = '0.1.5'
  s.summary          = 'FBPrivateCollect.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'help to Collect user device info or using data'

  s.homepage         = 'https://github.com/534219838@qq.com/FBPrivateCollect'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '534219838@qq.com' => 'wangwei_ios@smartisan.com' }
  s.source           = { :git => 'git@github.com:ywxkdz/FBDataCollect.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FBPrivateCollect/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FBPrivateCollect' => ['FBPrivateCollect/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
   s.dependency 'SAMKeychain'
   s.dependency 'Reachability'




end
