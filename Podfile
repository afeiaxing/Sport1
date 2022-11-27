# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'QYZY' do
	pod 'AFNetworking', :path => './QYZY/Util/AFNetworking'
  pod 'YYModel',  '1.0.4'
  pod 'YTKNetwork', :path => './QYZY/Util/YTKNetwork'
  pod 'SDWebImage', '5.13.2'
  pod 'Masonry'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'MJRefresh'
  pod 'DZNEmptyDataSet'
  pod 'QMUIKit'
  pod 'FunctionalObjC', '~> 1.0'
  pod 'JXCategoryView'
  pod 'FDFullscreenPopGesture'
  pod 'RongCloudIM/IMLib', '5.2.4'
  pod 'JCore', '~> 2.1.8-noidfa'
  pod 'JPush', '3.4.0'
  pod 'UMCCommon', '~> 2.1.4'
  pod 'UMCAnalytics'
  pod 'IQKeyboardManager',  '~> 6.4.2'
  pod 'YYCache'
  pod 'ZFPlayer', '~> 4.1.3'
  pod 'ZFPlayer/ControlView', '~> 4.1.3'
  pod 'SDCycleScrollView',  '~> 1.82'
  pod 'YYText'
  pod 'FGIAPService'
end

post_install do |installer|

installer.pods_project.targets.each do |target|

target.build_configurations.each do |config|

config.build_settings['ENABLE_BITCODE'] = 'NO'

end

end

end
