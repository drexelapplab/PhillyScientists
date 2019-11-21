source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'BioKids_Swift' do
    pod 'Alamofire', '~> 4.5'
    pod 'RealmSwift', '~> 3.20.0' 
    pod 'SwiftyJSON', '~> 4.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
