# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
inhibit_all_warnings!

target 'LoveHandler' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LoveHandler
  pod 'lottie-ios'
  pod "WaveAnimationView"
  pod 'DatePickerDialog'
  pod 'CombineCocoa'
  pod 'Fusuma'
  pod 'Hero'
  pod 'DeviceKit'
  pod 'Mantis', '~> 1.7.1'
  pod 'SwiftLint'
  pod 'KeychainSwift'
  pod 'Google-Mobile-Ads-SDK'

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end