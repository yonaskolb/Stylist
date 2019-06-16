Pod::Spec.new do |s|
  s.name         = "Stylist"
  s.version      = "0.3.0"
  s.swift_version = "5.0"
  s.summary      = "Define UI styles in a hot-loadable external yaml or json file"
  s.homepage     = "http://github.com/yonaskolb/Stylist"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Yonas Kolb" => "yonas4596@hotmail.com" }
  s.social_media_url   = "https://twitter.com/yonaskolb"
  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/yonaskolb/Stylist.git", :tag => s.version.to_s }
  s.source_files  = "Stylist/**/*.swift"
  s.frameworks  = "Foundation"
  s.dependency 'Yams', '~> 2.0.0'
  s.dependency 'KZFileWatchers', '~> 1.0.6'
end
