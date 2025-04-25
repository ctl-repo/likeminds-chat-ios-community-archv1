Pod::Spec.new do |spec|
  spec.name         = 'LikeMindsChatUI'
  spec.summary      = 'LikeMinds Chat UI official iOS SDK'
  spec.homepage     = 'https://likeminds.community/'
  spec.version      = '1.7.1'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors      = { 'pushpendrasingh' => 'pushpendra.singh@likeminds.community' }
  spec.source       = { :git => 'https://github.com/ctl-repo/likeminds-chat-ios-community-archv1.git', :branch => 'lmcv_dev_0.1' }
  
  spec.source_files = 'LMChatUI_iOS/LMChatUI_iOS/Source/**/*.swift'
  spec.resource_bundles = {
      'LikeMindsChatUI' => ['LikeMindsChatUI/LMChatUI_iOS/LMChatUI_iOS/Source/**/*.{xcassets}']
  }
  
  spec.ios.deployment_target = '13.0'
  spec.swift_version = '5.0'
  spec.requires_arc = true

  spec.dependency 'Kingfisher', '~> 7.0'
end
