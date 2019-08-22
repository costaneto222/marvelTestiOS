# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TesteiOS_Marvel' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  plugin 'cocoapods-keys', {
    :project => "TesteiOS_Marvel",
    :keys => [
      "MarvelApiKey",
      "MarvelPrivateKey"
    ]}

  # Pods for TesteiOS_Marvel
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'

  target 'TesteiOS_MarvelTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
  end
end
