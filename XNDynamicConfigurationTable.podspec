#
# Be sure to run `pod lib lint XNDynamicConfigurationTable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
Pod::Spec.new do |s|
  s.name             = 'XNDynamicConfigurationTable'
  s.version          = '0.1.0'
  s.summary          = 'A short description of XNDynamicConfigurationTable.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  A table page that dynamically changes the structure and data source according to the configuration table, and is suitable for various forms with simple structure but frequently changed fields.
                       DESC

  s.homepage         = 'https://github.com/yexiannan/XNDynamicConfigurationTable'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yexiannan' => '932056276@qq.com' }
  s.source           = { :git => 'https://github.com/yexiannan/XNDynamicConfigurationTable.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'XNDynamicConfigurationTable/Classes/**/*'
  
  # s.resource_bundles = {
  #   'XNDynamicConfigurationTable' => ['XNDynamicConfigurationTable/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'XNBaseUtils'
  s.dependency 'XNBaseUI'
  s.dependency 'XNBaseController'
  s.dependency 'YYModel'
  s.dependency 'Masonry'
  s.dependency 'XNNetWorkManager'
  s.dependency 'ReactiveObjC'
  s.prefix_header_contents = '#import "XNBaseUtils.h"','#import "Masonry.h"','#import "ReactiveObjC.h"','#import "XNBaseUI.h"','#import "XNBaseViewController.h"','#import "UINavigationController+XNBaseNavigationController.h"','#import "YYModel.h"'
end
