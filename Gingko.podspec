Pod::Spec.new do |s|
  s.name     = 'Gingko'
  s.version  = '0.0.1'
  s.summary  = 'Gingko is a framework wrapper around mobile platformvc and businesses of mobile Internet.'
  s.homepage = 'https://github.com/jcccn/Gingko'
  s.author   = { 'Chuncheng Jiang' => 'jccuestc@gmail.com' }
  s.license  = 'MIT'
  s.source   = { :git => 'https://github.com/jcccn/Gingko.git', :tag => s.version }
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.default_subspec = 'Full'

  ### Subspecs

  s.subspec 'Full' do |full|
    full.requires_arc = true
    full.dependency 'Gingko/Core'
    full.dependency 'Gingko/MVC'
    full.dependency 'Gingko/Service'
  end

  s.subspec 'Core' do |core|
    core.requires_arc = true
    core.dependency 'SDWebImage'
    core.dependency 'RestKit'
    core.dependency 'BDMultiDownloader'
    core.dependency 'BlocksKit'
    core.dependency 'Reachability'
    core.dependency 'UIImage-Categories'
    core.dependency 'ELCImagePickerController'
    core.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
    core.libraries  = 'icucore', 'z.1.2.5', 'z', 'sqlite3'
    core.resources = "Gingko-iOS/Gingko/Core/**/*.{h,m,mm,c}"
  end

  s.subspec 'MVC' do |mvc|
    mvc.requires_arc = true
    mvc.dependency 'Gingko/Core'
    mvc.dependency 'WebViewJavascriptBridge'
    mvc.dependency 'ADTransitionController'
    mvc.resources = "Gingko-iOS/Gingko/MVC/**/*.{h,m,mm,c}"
  end

  s.subspec 'Service' do |service|
    service.requires_arc = true
    service.dependency 'Gingko/Core'
    service.dependency 'Gingko/MVC'
    service.dependency 'BaiduMap'
    service.resources = "Gingko-iOS/Gingko/Service/**/*.{h,m,mm,c}"
  end

end
