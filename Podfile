use_frameworks!

def test_pods
  pod 'Quick'
  pod 'Nimble'
end

def stylist_pods
  pod 'Yams'
end

target 'Example' do
  platform :ios, '10.0'
  pod 'KZFileWatchers', :git=> 'https://github.com/yonaskolb/KZFileWatchers', :branch=> 'tvOS'
  stylist_pods
end

target 'Stylist-iOS' do
  platform :ios, '10.0'
  stylist_pods
end

target 'Stylist-tvOS' do
  platform :tvos, '10.0'
  stylist_pods
end

target 'Stylist-macOS' do
  platform :watchos, '2.0'
  stylist_pods
end

target 'Stylist-watchOS' do
  platform :osx, '10.10'
  stylist_pods
end

target 'Stylist-iOS Tests' do
  platform :ios, '10.0'
  test_pods
end

target 'Stylist-tvOS Tests' do
  platform :tvos, '10.0'
  test_pods
end

target 'Stylist-macOS Tests' do
  platform :osx, '10.10'
  test_pods
end
