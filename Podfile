# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'RubyWriter' do
  use_frameworks!

  pod 'SwiftLint'

  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxAlamofire'

  pod 'TextFieldEffects'
  pod 'SwiftIconFont'
  pod 'NVActivityIndicatorView'

  target 'RubyWriterTests' do
    inherit! :search_paths
    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'
    pod 'Mockingjay', '3.0.0-alpha.1'
  end

end
