Pod::Spec.new do |s|
  s.name         = "JJKit"
  s.version      = "1.0.8"
  s.summary      = "包括便捷扩展、路由、轮播图、转场动画的框架"
  s.homepage     = "https://github.com/zgjff/JJKit"
  s.license      = "MIT"
  s.author       = { "zgj" => "zguijie1005@qq.com" }
  s.source       = { :git => "https://github.com/zgjff/JJKit.git", :tag => s.version }

  s.description = '此框架包含了一下几种可用功能 '      \
                    '便捷扩展: 快速创建颜色图片、形状图片、给图片添加滤镜、UIControl添加block回调 '    \
                    '路由: 适用于Swift的简单好用、支持block回调、转发、拦截功能的路由框架 '      \
                    '轮播图: 泛型、block、无任何第三方、易于扩展的轮播图框架 '  \
                    '转场动画: 便捷的custom转场动画助手、类似push\pop的present转场'

  s.subspec 'JJExtension' do |ss|
    ss.source_files = "Sources/Utils/**/*.{swift}", "Sources/Extensions/**/*.{swift}"
  end

  s.subspec 'JJCarouselView' do |ss|
     ss.source_files = "Sources/CarouselView/**/*.{swift}"
     ss.dependency 'JJKit/JJExtension'
  end

  s.subspec 'JJRouter' do |ss|
     ss.source_files = "Sources/Router/**/*.{swift}"
     ss.dependency 'JJKit/JJExtension'
  end

  s.subspec 'JJTransition' do |ss|
     ss.source_files = "Sources/Transitions/**/*.{swift}"
     ss.dependency 'JJKit/JJExtension'
  end

  s.subspec 'JJToast' do |ss|
     ss.source_files = "Sources/Toast/**/*.{swift}"
     ss.dependency 'JJKit/JJExtension'
  end

  s.platform     = :ios, "11.0"
  s.swift_version = '5.5'
end
