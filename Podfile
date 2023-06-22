# Uncomment the next line to define a global platform for your project
# platform :ios, '12.2'

target 'WooBox' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WooBox
pod 'SRScratchView'
pod 'IQKeyboardManagerSwift'
pod 'SwiftGifOrigin'
pod 'Alamofire', '~> 4.8.1'
pod 'Fabric'
pod 'Crashlytics'
pod 'SideMenu'
pod 'FCAlertView'
pod 'REFrostedViewController', '~> 2.4'
pod 'MBProgressHUD'
pod 'SDWebImage'
pod 'AnimatedCollectionViewLayout'
pod 'MultiSlider'
pod 'Cosmos'
pod 'Toast-Swift'
pod 'OAuthSwiftAlamofire', '~> 0.2.0'
pod 'OAuthSwift', '~> 1.3.0'
pod 'Firebase/Analytics'
pod 'Google-Mobile-Ads-SDK'
pod 'Firebase/Core', '~> 6.7.0'
pod 'FirebaseAuth', '~> 6.2.3'
pod 'GoogleSignIn'
pod 'FacebookLogin'
pod 'OneSignal', '>= 2.11.2', '< 3.0'

target 'OneSignalNotificationServiceExtension' do
  pod 'OneSignal', '>= 2.11.2', '< 3.0'
end

  target 'WooBoxTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WooBoxUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'No'
     end
  end
end
