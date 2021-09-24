platform :ios, '14.1'

inhibit_all_warnings!

use_frameworks!

target 'Lemmy-iOS' do
  pod 'Nuke', '~> 9.0'
  pod 'DateToolsSwift', '~> 5.0.0'
  pod 'Pageboy', '~> 3.6'
  pod 'Lightbox', '~> 2.5'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
