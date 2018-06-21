Pod::Spec.new do |s|
  s.name             = "ABCPaiti"
  s.version          = "0.0.3"
  s.summary          = "ABCPaiti."
  s.description      = "ABCPaiti of bing"
  s.homepage         = "http://www.abcpen.com"
  s.license          = 'MIT'
  s.author           = { "bing" => "bing@abcpen.com" }
  s.source           = { :git => 'https://github.com/BingO0o/ABCPaitiKit.git' }
  s.platform         = :ios, '9.0'
  s.requires_arc     = true

  s.subspec 'ABCPaitiKit' do |sp|
    sp.public_header_files = 'ABCPitiSDK/ABCPaitiKit.framework/Headers/ABCPaitiKit.h'
    sp.source_files        = 'ABCPitiSDK/ABCPaitiKit.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'ABCPitiSDK/ABCPaitiKit.framework'
    sp.dependency 'AFNetworking', '~> 3.1.0'
    sp.dependency 'SAMKeychain', '~> 1.5.3'
    sp.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  end

end
