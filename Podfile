# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'Templates' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Templates

  pod 'd1-libs-debug', :path => './Libs/d1-libs-debug', :configurations => ['Debug']
  pod 'd1-libs-release', :path => './Libs/d1-libs-release', :configurations => ['Release']

end

target 'WalletExtensionUI' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Templates

  pod 'd1-libs-debug', :path => './Libs/d1-libs-debug', :configurations => ['Debug']
  pod 'd1-libs-release', :path => './Libs/d1-libs-release', :configurations => ['Release']

end

target 'WalletExtension' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Templates

  pod 'd1-libs-debug', :path => './Libs/d1-libs-debug', :configurations => ['Debug']
  pod 'd1-libs-release', :path => './Libs/d1-libs-release', :configurations => ['Release']

end


post_install do |installer|
  # Configure the Pods project
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['DEAD_CODE_STRIPPING'] = 'YES'
  end

  # Configure the Pod targets
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'DEAD_CODE_STRIPPING'
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end


