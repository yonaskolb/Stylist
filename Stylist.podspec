Pod::Spec.new do |s|
  s.name         = "Stylist"
  s.version      = "0.1"
  s.summary      = "Style your app with YAML"
  s.description  = "Style your app with YAML"
  s.homepage     = "http://github.com/yonaskolb/Stylist"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Yonas Kolb" => "yonas4596@hotmail.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/yonaskolb/Stylist.git", :tag => s.version.to_s }
  s.source_files  = "Stylist/**/*.swift"
  s.frameworks  = "Foundation"
  s.dependency 'Yams'
  s.dependency 'KZFileWatchers'
end
