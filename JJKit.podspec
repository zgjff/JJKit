Pod::Spec.new do |s|
  s.name         = "JJKit"
  s.version      = "0.1.1"
  s.summary      = "Layout框架/快速设定UITableView,UICollectionView,UIScrollView代理/extension等."
  s.homepage     = "https://github.com/zgjff/JJKit"
  s.license      = "MIT"
  s.author       = { "zgj" => "zguijie1005@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/zgjff/JJKit.git", :tag => s.version }
  s.source_files  = "Sources/**/*.{swift}"
  s.resource_bundles = {
    'JJKit' => ['Resources/*.{ttf}']
  }
  s.swift_version = '5.0'
  s.requires_arc = true
end
