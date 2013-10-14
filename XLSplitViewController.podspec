Pod::Spec.new do |s|
  s.name         = "XLSplitViewController"
  s.version      = "0.2.1"
  s.summary      = "a splitViewController work like apple's one, and can customize some attributes."
  s.homepage     = "https://github.com/kaizeiyimi/XLSplitViewController"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "王凯" => "kaizeiyimi@126.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/kaizeiyimi/XLSplitViewController.git", :tag => "v0.2.1" }
  s.source_files  = 'codes/*.{h,m}'
  s.requires_arc = true
end
