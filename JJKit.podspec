Pod::Spec.new do |s|
  s.name         = "JJKit"
  s.version      = "0.0.161"
  s.summary      = "常用的基础控件/extension等."
  s.homepage     = "https://github.com/zgjff/JJKit"
  s.license      = "MIT"
  s.author             = { "zgj" => "zguijie1005@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/zgjff/JJKit.git", :tag => "0.0.161" }
  s.source_files  = "Sources/**/*.{swift}"
  s.resource_bundles = {
    'JJKit' => ['Resources/*.{ttf}']
  }
  s.swift_version = '4.2'
  s.requires_arc = true
end
