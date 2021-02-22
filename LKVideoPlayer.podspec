#
# Be sure to run `pod lib lint LKVideoPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'LKVideoPlayer'
  spec.version          = '0.0.7'
  spec.summary          = 'A short description of LKVideoPlayer.'

  spec.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

    spec.homepage         = 'http://git.luckincoffee.com/lkm-dev/MediaBrowseKit-iOS'
    spec.license          = { :type => 'MIT', :file => 'LICENSE' }
    spec.author           = { 'allen' => 'haibi.gao@luckincoffee.com' }
    spec.source           = { :git => 'http://git.luckincoffee.com/lkm-dev/MediaBrowseKit-iOS.git', :tag => spec.version }

    spec.platform     = :ios, "10.0"
    spec.source_files = 'LKVideoPlayer/Classes/*.{h,m}'
    spec.public_header_files = 'LKVideoPlayer/Classes/*.h'
    spec.resource_bundles = {
        'NEDADVideoPlayer' => ['LKVideoPlayer/Assets/*.png']
       }
    spec.static_framework = true
    spec.frameworks = 'AudioToolbox','VideoToolbox','AVFoundation','CoreMedia','CoreTelephony','GLKit','MobileCoreServices','OpenAL','SystemConfiguration'
    spec.libraries = 'sqlite3.0', 'bz2', 'z', 'c++', 'iconv.2.4.0'
    spec.frameworks = 'AVKit'
    spec.dependency 'Masonry'
    spec.dependency 'SDWebImage'
    spec.vendored_frameworks = 'LKVideoPlayer/*.framework'
    spec.dependency 'NEDMacros'
    
    spec.subspec 'Model' do |subSpec|
        subSpec.source_files = "LKVideoPlayer/Classes/Model/*.{h,m}"
    end
    
    spec.subspec 'View' do |subSpec|
        subSpec.source_files = "LKVideoPlayer/Classes/View/*.{h,m}"
    end
    
    spec.subspec 'Manager' do |subSpec|
        subSpec.source_files = "LKVideoPlayer/Classes/Manager/*.{h,m}"
    end
    
    spec.subspec 'Tool' do |subSpec|
        subSpec.source_files = "LKVideoPlayer/Classes/Tool/*.{h,m}"
    end
end

