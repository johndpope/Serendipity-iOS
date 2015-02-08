platform :ios, '8.0'

inhibit_all_warnings!

pod 'ReactiveCocoa', '~> 2.4' # Update to 3.0 when ready

pod 'SugarRecord/CoreData', :git => 'https://github.com/tonyxiao/SugarRecord'
pod 'Meteor', '~> 0.1'
pod 'Alamofire', '~> 1.1'

pod 'Facebook-iOS-SDK', '~> 3.22'
pod 'GPUImage', '~> 0.1.6'
pod 'DateTools', '~> 1.5'
pod 'SwiftyJSON', '~> 2.1'
#pod 'ExSwift', '~> 0.1.9'

pod 'SwipeView', '~> 1.3'
pod 'SDWebImage', '~> 3.7'
pod 'Snap', '~> 0.0.4'

# Debug only

pod 'Reveal-iOS-SDK', '~> 1.5', :configuration => ['Debug']
pod 'NSLogger', '~> 1.5', :configuration => ['Debug']

# Hacks
post_install do |installer|
    installer.project.targets.each do |target|
        # DateTools Hack https://github.com/MatthewYork/DateTools/issues/56 Disable localization in exchange for no crash
        if target.name == 'Pods-DateTools'
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'DateToolsLocalizedStrings(key)=key'
            end
        end
    end
end
