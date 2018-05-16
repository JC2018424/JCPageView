
Pod::Spec.new do |s|
s.name         = 'JCPageView'
s.version      = '0.0.1'
s.summary      = '简单实用的pageView,实现分页效果'
s.homepage     = 'https://github.com/JC2018424/JCPageView'
s.license      = 'MIT'
s.authors      = {'JC' => '13451001517@163.com'}
s.platform     = :ios, '9.0'
s.source       = {:git => 'https://github.com/JC2018424/JCPageView.git', :tag => s.version}
s.source_files = 'JCPageView/*.swift'
s.requires_arc = true
s.framework  = 'UIKit'
s.dependency 'Then', '~> 2.3.0'
s.dependency 'SnapKit', '~> 4.0'

s.swift_version    = '4.0'
end



