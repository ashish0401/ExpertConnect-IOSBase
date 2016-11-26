# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'ExpertConnect' do
	pod 'Alamofire', '~> 4.0'
	pod 'Locksmith', '~> 3.0'
	pod ‘Cosmos’, ‘~> 1.0’
	pod 'MBProgressHUD', '~> 1.0.0'
	pod 'SwiftyJSON'
    pod 'Kingfisher', '~> 3.0'
end

  target 'ExpertConnectTests' do
    inherit! :search_paths
  end

  target 'ExpertConnectUITests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
