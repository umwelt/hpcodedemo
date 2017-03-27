platform :ios, '10.0'

target 'Grocerest' do
  use_frameworks!
  pod 'RealmSwift'
  pod 'GoogleMaps'
  pod 'HanekeSwift', :git => 'https://github.com/Haneke/HanekeSwift.git', :branch => 'feature/swift-3'
  pod 'SwiftLoader', :git => 'https://github.com/kevinmanncito/SwiftLoader.git', :branch => 'swift3'
  pod 'SnapKit'
  pod 'Socket.IO-Client-Swift'
  pod 'Alamofire'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'SwiftyJSON'
  pod 'Google/Analytics'
  pod 'Tune'
  pod 'ZendeskSDK'
  pod 'TagListView'
  pod 'Branch'

  react_path = 'node_modules/react-native'
  yoga_path = File.join(react_path, 'ReactCommon/yoga')

  pod 'Yoga', :path => yoga_path
  pod 'React', :path => react_path, :subspecs => [
    'Core',
    'RCTText',
    'RCTNetwork',
    'RCTWebSocket', # needed fr debugging
    'RCTImage',
    'RCTLinkingIOS'
    # Add any other subspecs you want to use in your project
  ]

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
  end
